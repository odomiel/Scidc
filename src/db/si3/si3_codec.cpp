// ======================================================================
// Author : $Author$
// Version: $Revision: 1497 $
// Date   : $Date: 2018-07-08 13:09:06 +0000 (Sun, 08 Jul 2018) $
// Url    : $URL$
// ======================================================================

// ======================================================================
//    _/|            __
//   // o\         /    )           ,        /    /
//   || ._)    ----\---------__----------__-/----/__-
//   //__\          \      /   '  /    /   /    /   )
//   )___(     _(____/____(___ __/____(___/____(___/_
// ======================================================================

// ======================================================================
// Copyright: (C) 2009-2013 Gregor Cramer
// ======================================================================

// ======================================================================
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
// ======================================================================

#include "si3_codec.h"
#include "si3_stored_line.h"
#include "si3_name_list.h"
#include "si3_decoder.h"
#include "si3_encoder.h"
#include "si3_consumer.h"
#include "si3_common.h"

#include "db_game_data.h"
#include "db_game_info.h"
#include "db_producer.h"
#include "db_reader.h"
#include "db_eco_table.h"
#include "db_exception.h"

#include "nsError.h"

#include "u_byte_stream.h"
#include "u_block_file.h"
#include "u_progress.h"
#include "u_misc.h"

#include "sys_time.h"
#include "sys_file.h"
#include "sys_utf8.h"
#include "sys_utf8_codec.h"

#include "m_function.h"
#include "m_fstream.h"
#include "m_utility.h"
#include "m_assert.h"

#include "m_stdio.h"

#include <cstring>
#include <cctype>
#include <utility>

using namespace db;
using namespace db::si3;
using namespace util;


typedef ByteStream::uint24_t uint24_t;


static unsigned const MaxIndexEntrySize	= 56; // extended for si5
static unsigned const MaxIndexHeaderSize	= 174;
static unsigned const MaxFrequency			= 0xffffff;
static unsigned const MaxRoundCount			= (1 << 18) - 1;

static mstl::string const MagicIndexFile("Scid.si\0", 8);
static mstl::string const MagicGameFile("Scid.sg\0", 8);
static mstl::string const MagicNamebase("Scid.sn\0", 8);
static mstl::string const Ext3("si3");
static mstl::string const Ext4("si4");
static mstl::string const Ext5("si5");


static unsigned
strippedLength(char const* s, unsigned len)
{
	while (len > 0 && ::isspace(s[len - 1]))
		--len;

	return len;
}


inline
static void
swapByte(unsigned char& c)
{
	c = ((c & 0x0f) << 4) | ((c & 0xf0) >> 4);
}


static void
swapHomePawnBytes(unsigned char* data)
{
	swapByte(data[0]);
	swapByte(data[1]);
	swapByte(data[2]);
	swapByte(data[3]);
	swapByte(data[4]);
	swapByte(data[5]);
	swapByte(data[6]);
	swapByte(data[7]);
}


template <typename T>
static inline T*
check(T* p)
{
	if (!p)
		IO_RAISE(Index, Corrupted, "pointer is null");
	return p;
}


static void
checkNamebase(unsigned maxFrequency, char const* msg)
{
	if (maxFrequency > MaxFrequency)
		IO_RAISE(Namebase, Encoding_Failed, msg);
}


static unsigned
prefix(char const* s, char const* t)
{
	unsigned count = 0;

	for ( ; *s == *t; ++s, ++t, ++count)
		M_ASSERT(*s);

	return count;
}


static void
writeFrequency(ByteStream& bstrm, unsigned freq, unsigned maxFreq)
{
	M_ASSERT(freq <= ::MaxFrequency);
	M_ASSERT(freq <= maxFreq);

	if (maxFreq < 256)
		bstrm << uint8_t(freq);
	else if (maxFreq < 65536)
		bstrm << uint16_t(freq);
	else
		bstrm << uint24_t(freq);
}


static void
writeId(ByteStream& bstrm, unsigned id, unsigned maxId)
{
	if (maxId >= 65536)
		bstrm << uint24_t(id);
	else
		bstrm << uint16_t(id);
}


struct Codec::ByteIStream : public ByteStream
{
	ByteIStream(mstl::fstream& strm);

	void underflow(unsigned size);
	void reset();

	mstl::istream& m_strm;
	unsigned m_offset;
};


Codec::ByteIStream::ByteIStream(mstl::fstream& strm)
	:ByteStream(strm.bufsize())
	,m_strm(strm)
	,m_offset(0)
{
	m_getp = m_endp;	// force underflow
}


void
Codec::ByteIStream::underflow(unsigned size)
{
	M_ASSERT(size <= capacity());

	unsigned remaining = this->remaining();
	::memmove(m_base, m_getp, remaining);
	m_getp = m_base + remaining;
	m_endp = m_getp + m_strm.readsome(reinterpret_cast<char*>(m_getp), capacity() - remaining);
	m_getp -= remaining;

	if (__builtin_expect(m_getp >= m_endp, 0))
		IO_RAISE(Namebase, Corrupted, "unexpected end of stream");
}


void
Codec::ByteIStream::reset()
{
	m_getp = m_endp;	// force underflow
}


struct Codec::ByteOStream : public ByteStream
{
	ByteOStream(mstl::ostream& strm, unsigned char* buf, unsigned size);
	void overflow(unsigned size);
	void flush();
	mstl::ostream& m_strm;
};


Codec::ByteOStream::ByteOStream(mstl::ostream& strm, unsigned char* buf, unsigned size)
	:ByteStream(buf, size)
	,m_strm(strm)
{
}


void
Codec::ByteOStream::overflow(unsigned size)
{
	if (__builtin_expect(!m_strm.write(m_base, m_putp - m_base), 0))
		IO_RAISE(Namebase, Write_Failed, "write failed");

	m_putp = m_base;
}


void
Codec::ByteOStream::flush()
{
	if (__builtin_expect(!m_strm.write(m_base, m_putp - m_base), 0))
		IO_RAISE(Namebase, Write_Failed, "write failed");

	m_putp = m_base;
}


Codec::Codec(CustomFlags* customFlags, bool isVersion5)
	:m_headerSize(isVersion5 ? 174 : (customFlags ? 174 : 120))	// w/o magic
	,m_indexEntrySize(isVersion5 ? 56 : (customFlags ? 47 : 46))
	,m_fileVersion(isVersion5 ? 500 : (customFlags ? 400 : 300))
	,m_isVersion5(isVersion5)
	,m_autoLoad(0)
	,m_extIndex(isVersion5 ? ".si5" : (customFlags ? ".si4" : ".si3"))
	,m_extGame(isVersion5 ? ".sg5" : (customFlags ? ".sg4" : ".sg3"))
	,m_extNamebase(isVersion5 ? ".sn5" : (customFlags ? ".sn4" : ".sn3"))
	,m_blockSize(customFlags ? 131072 : 32768)
	,m_encoding(sys::utf8::Codec::utf8())
	,m_customFlags(customFlags)
	,m_hasMagic(false)
	,m_playerList(new NameList)
	,m_eventList(new NameList)
	,m_siteList(new NameList)
	,m_roundList(new NameList)
	,m_roundEntry(0)
	,m_progressFrequency(0)
	,m_progressReportAfter(0)
	,m_progressCount(0)
{
	M_ASSERT(m_indexEntrySize <= MaxIndexEntrySize);

	m_magicGameFile = MagicGameFile;
	m_magicGameFile.resize(MagicGameFile.size() + 2);

	ByteStream strm(m_magicGameFile.data(), m_magicGameFile.size());
	strm.advance(MagicGameFile.size());
	strm << uint16_t(m_fileVersion);

	StoredLine::initialize();
}


Codec::~Codec() noexcept
{
	if (m_progressiveStream)
		m_progressiveStream->close();
}


unsigned Codec::maxGameRecordLength() const	{ return m_blockSize - 1; }
unsigned Codec::maxGameLength() const			{ return (1 << 10) - 1; }
// IMPORTANT NOTE:
// Scid-vs-PC supports 2^24-2 games, but mainline Scid supports only 16,000,000 games.
unsigned Codec::maxGameCount() const			{ return (1 << 24) - 2; }
unsigned Codec::maxPlayerCount() const			{ return (1 << 20) - 1; }
unsigned Codec::maxEventCount() const			{ return (1 << 19) - 1; }
unsigned Codec::maxSiteCount() const			{ return (1 << 19) - 1; }
unsigned Codec::maxAnnotatorCount() const		{ return 0; }
unsigned Codec::minYear() const					{ return Date::MinYear; }
unsigned Codec::maxYear() const					{ return mstl::min(uint16_t(2047), Date::MaxYear); }
unsigned Codec::maxDescriptionLength() const	{ return 107; }
mstl::string const& Codec::extension() const
{
	if (m_isVersion5) return Ext5;
	return m_customFlags ? Ext4 : Ext3;
}
mstl::string const& Codec::defaultEncoding() const { return sys::utf8::Codec::utf8(); }


unsigned
Codec::gameFlags() const
{
	enum
	{
		Flags =		GameInfo::Flag_White_Opening
					 | GameInfo::Flag_Black_Opening
					 | GameInfo::Flag_Middle_Game
					 | GameInfo::Flag_End_Game
					 | GameInfo::Flag_Novelty
					 | GameInfo::Flag_Pawn_Structure
					 | GameInfo::Flag_Tactics
					 | GameInfo::Flag_King_Side
					 | GameInfo::Flag_Queen_Side
					 | GameInfo::Flag_Brilliancy
					 | GameInfo::Flag_Blunder
					 | GameInfo::Flag_User,

		UserFlags =	GameInfo::Flag_User1
					 | GameInfo::Flag_User2
					 | GameInfo::Flag_User3
					 | GameInfo::Flag_User4
					 | GameInfo::Flag_User5
					 | GameInfo::Flag_User6
	};

	return m_customFlags ? Flags | UserFlags : Flags;
}


void
Codec::Report(char const* charset)
{
	if (::sys::utf8::Codec::ascii() != charset)
		m_encoding.assign(charset);
}


Codec::Format
Codec::format() const
{
	if (m_isVersion5) return format::Scid5;
	return m_customFlags ? format::Scid4 : format::Scid3;
}


bool
Codec::isWritable() const
{
	return true;
}


bool
Codec::encodingFailed() const
{
	M_ASSERT(m_codec);
	return m_codec->failed();
}


mstl::string const&
Codec::encoding() const
{
	M_ASSERT(m_codec);
	return m_codec->encoding();
}


db::tag::TagSet
Codec::tagFilter(Section section, TagSet const& tags) const
{
	tag::TagSet infoTags = Encoder::infoTags();

	infoTags.set(tag::EventDate);

	if (section == GameTags && tags.contains(tag::Date) && tags.contains(tag::EventDate))
	{
		unsigned dy = Date(tags.value(tag::Date)).year();
		unsigned ey = Date(tags.value(tag::EventDate)).year();

		if (mstl::abs(dy - ey) > 3)
			infoTags.reset(tag::EventDate);
	}

	return infoTags;
}


bool
Codec::isExtraTag(tag::ID tag)
{
	return Encoder::isExtraTag(tag);
}


void
Codec::reset()
{
	M_ASSERT(m_codec);
	return m_codec->reset();
}


void
Codec::setEncoding(mstl::string const& encoding)
{
	M_ASSERT(m_codec);
	m_codec->reset(encoding);
}


void
Codec::setWritable()
{
	if (!m_gameStream.is_writable())
		m_gameStream.reopen(mstl::ios_base::in | mstl::ios_base::out | mstl::ios_base::binary);
}


void
Codec::close()
{
	m_gameData->close();
}


void
Codec::sync()
{
	m_gameData->sync();
}


util::ByteStream
Codec::getGame(GameInfo const& info)
{
	M_ASSERT(m_gameData);

	ByteStream src;
	getGameRecord(info, m_gameData->reader(), src);
	return src;
}


unsigned
Codec::putGame(ByteStream const& strm)
{
	M_ASSERT(m_gameData);
	return m_gameData->put(strm);
}


unsigned
Codec::putGame(ByteStream const& strm, unsigned prevOffset, unsigned prevRecordLength)
{
	M_ASSERT(m_gameData);
	return m_gameData->put(strm, prevOffset, prevRecordLength);
}


unsigned
Codec::doDecoding(::util::BlockFileReader* asyncReader,
						GameInfo const& info,
						uint16_t* line,
						unsigned length,
						Board& startBoard,
						bool useStartBoard)
{
	M_ASSERT(asyncReader);

	ByteStream strm;
	getGameRecord(info, *asyncReader, strm);
	Decoder decoder(strm, *m_codec);
	return decoder.doDecoding(line, length, startBoard, useStartBoard);
}


save::State
Codec::doDecoding(db::Consumer& consumer, TagSet& tags, GameInfo const& info, unsigned gameIndex)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	ByteStream strm;
	getGameRecord(info, m_gameData->reader(), strm);
	Decoder decoder(strm, *m_codec);
	return decoder.doDecoding(consumer, tags);
}


save::State
Codec::doDecoding(db::Consumer& consumer, ByteStream& strm, TagSet& tags)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	Decoder decoder(strm, *m_codec);
	return decoder.doDecoding(consumer, tags);
}


void
Codec::doDecoding(GameData& data, GameInfo& info, unsigned gameIndex, mstl::string* encoding)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	ByteStream strm;
	getGameRecord(info, m_gameData->reader(), strm);

	Decoder decoder(strm, *m_codec);

	M_ASSERT(strm.size() == info.gameRecordLength());

	info.m_plyCount = mstl::min(GameInfo::MaxPlyCount, decoder.doDecoding(data));

	if (encoding)
		*encoding = decoder.encoding();

	if (data.m_tags.contains(tag::Termination) && info.terminationReason() == termination::Unknown)
		info.m_termination = termination::fromString(data.m_tags.value(tag::Termination));

#if 0
// NOTE: We cannot do this because the order in the namebase will be corrupted!
// ----------------------------------------------------------------------------
	if (data.m_tags.contains(tag::EventDate) && !info.m_event->hasDate())
		info.m_event->setDate(Date(data.m_tags.value(tag::EventDate)));

	if (data.m_tags.contains(tag::EventType) && info.m_event->type() == event::Unknown)
	{
		mstl::string const& value = data.m_tags.value(tag::EventType);

		event::Type eventType = event::typeFromString(value);

		if (eventType != event::Unknown)
		{
			info.m_event->setType(eventType);
		}
		else if (info.m_event->timeMode() == time::Unknown)
		{
			time::Mode timeMode = time::fromString(value);

			if (timeMode == time::Unknown && value.back() == ')')
			{
				char const* s = ::strchr(value, '(');

				if (s)
				{
					mstl::string str(s + 1, value.end() - 2);
					timeMode = time::fromString(str);
				}
			}

			info.m_event->setTimeMode(timeMode);
		}
	}

	if (data.m_tags.contains(tag::TimeControl) && info.m_event->timeMode() == time::Unknown)
	{
		info.m_event->setTimeMode(
			Reader::getTimeModeFromTimeControl(data.m_tags.value(tag::TimeControl)));
	}

	if (data.m_tags.contains(tag::Mode))
	{
		event::Mode eventMode = event::modeFromString(data.m_tags.value(tag::Mode));

		if (info.m_event->eventMode() == event::Undetermined)
			info.m_event->setEventMode(eventMode);

		if (info.m_event->timeMode() == time::Unknown)
		{
			switch (int(eventMode))
			{
				case event::PaperMail:
				case event::Email:
					info.m_event->setTimeMode(time::Corr);
					break;
			}
		}
	}
#endif
}


void
Codec::doOpen(mstl::string const& encoding)
{
	M_ASSERT(	m_codec == nullptr
				|| encoding == sys::utf8::Codec::automatic()
				|| encoding == m_codec->encoding());
	M_ASSERT(m_gameData == nullptr);

	m_codec.reset(new sys::utf8::Codec(encoding));
	M_ASSERT(encoding == sys::utf8::Codec::automatic() || m_codec->hasEncoding());
	m_gameData.reset(new BlockFile(m_blockSize, BlockFile::RequireLength, m_magicGameFile));
	m_hasMagic = true;
}


void
Codec::doOpen(	mstl::string const& rootname,
					mstl::string const& originalSuffix,
					mstl::string const& encoding,
					util::Progress& progress)
{
	M_ASSERT(originalSuffix == "si3" || originalSuffix == "si4" || originalSuffix == "si5");
	M_ASSERT(	m_codec == nullptr
				|| encoding == sys::utf8::Codec::automatic()
				|| encoding == m_codec->encoding());
	M_ASSERT(m_gameData == nullptr);

	char buf[8];

	m_codec.reset(new sys::utf8::Codec(encoding));
	M_ASSERT(encoding == sys::utf8::Codec::automatic() || m_codec->hasEncoding());

	mstl::string indexFilename(rootname + m_extIndex);
	mstl::string gameFilename(rootname + m_extGame);
	mstl::string namebaseFilename(rootname + m_extNamebase);

	checkPermissions(gameFilename);
	checkPermissions(indexFilename);
	checkPermissions(namebaseFilename);

	mstl::fstream indexStream;
	mstl::fstream namebaseStream;

	m_gameStream.set_unbuffered();

	if (m_isVersion5) {
		openFile(m_gameStream, gameFilename);
		openFile(indexStream, indexFilename);
		readNamebasesSi5(namebaseFilename, progress);
		readIndex(indexStream, progress);
	} else {
		openFile(m_gameStream, gameFilename);
		openFile(namebaseStream, namebaseFilename, MagicNamebase);
		openFile(indexStream, indexFilename, MagicIndexFile);

		if (m_gameStream.size() >= 8 && m_gameStream.read(buf, 8) && ::memcmp(buf, MagicGameFile, 8) == 0)
			m_hasMagic = true;

		readNamebases(namebaseStream, progress);
		readIndex(indexStream, progress);
	}

	// NOTE:
	// 1. we cannot trust the maximal frequency, Scid's value is possibly faulty
	// 2. we need to recompute the frequency values of the Event and Site bases
	namebases().setModified(false);
	namebases().update();

	if (m_isVersion5)
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength));
	else if (m_hasMagic)
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength, m_magicGameFile));
	else
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength));
}


void
Codec::doOpen(mstl::string const& rootname, mstl::string const& encoding)
{
	M_ASSERT(	m_codec == nullptr
				|| encoding == sys::utf8::Codec::automatic()
				|| encoding == m_codec->encoding());
	M_ASSERT(m_gameData == nullptr);

	m_codec.reset(new sys::utf8::Codec(encoding));
	M_ASSERT(encoding == sys::utf8::Codec::automatic() || m_codec->hasEncoding());

	mstl::string indexFilename(rootname + m_extIndex);
	mstl::string gameFilename(rootname + m_extGame);
	mstl::string namebaseFilename(rootname + m_extNamebase);

	mstl::fstream indexStream;
	mstl::fstream namebaseStream;

	m_gameStream.set_unbuffered();

	if (m_isVersion5) {
		openFile(m_gameStream, gameFilename, Truncate);
		openFile(indexStream, indexFilename, Truncate);
		// si5 namebase written separately (no magic)
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength));
		m_gameData->sync();
		writeNamebasesSi5(namebaseFilename);
		// index header: none for si5
	} else {
		openFile(m_gameStream, gameFilename, Truncate);
		openFile(indexStream, indexFilename, MagicIndexFile, Truncate);
		openFile(namebaseStream, namebaseFilename, MagicNamebase, Truncate);
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength, m_magicGameFile));
		m_gameData->sync();
		m_hasMagic = true;
		writeNamebases(namebaseStream);
		writeIndexHeader(indexStream);
	}
}


unsigned
Codec::doOpenProgressive(mstl::string const& rootname, mstl::string const& encoding)
{
	M_ASSERT(m_progressiveStream == nullptr);

	m_codec.reset(new sys::utf8::Codec(encoding));

	mstl::string indexFilename(rootname + m_extIndex);
	mstl::string gameFilename(rootname + m_extGame);
	mstl::string namebaseFilename(rootname + m_extNamebase);

	mstl::fstream namebaseStream;

	m_progressiveStream.reset(new mstl::fstream);
	m_gameStream.set_unbuffered();

	openFile(m_gameStream, gameFilename, Readonly);
	openFile(*m_progressiveStream, indexFilename, MagicIndexFile, Readonly);
	openFile(namebaseStream, namebaseFilename, MagicNamebase, Readonly);

	unsigned numGames;

	readIndexHeader(*m_progressiveStream, &numGames);
	m_roundLookup.resize(numGames);

	::util::Progress progress;
	readNamebases(namebaseStream, progress);
	namebaseStream.close();
	m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength, m_magicGameFile));

	return numGames;
}


void
Codec::doClear(mstl::string const& rootname)
{
	M_ASSERT(m_codec);
	M_ASSERT(m_gameData);

	mstl::string indexFilename(rootname + m_extIndex);
	mstl::string gameFilename(rootname + m_extGame);
	mstl::string namebaseFilename(rootname + m_extNamebase);

	mstl::fstream indexStream;
	mstl::fstream namebaseStream;

	if (m_isVersion5) {
		openFile(indexStream, indexFilename, Truncate);
	} else {
		openFile(indexStream, indexFilename, MagicIndexFile, Truncate);
		openFile(namebaseStream, namebaseFilename, MagicNamebase, Truncate);
	}

	m_gameData->close();
	m_gameData.reset();
	m_gameStream.truncate(0);
	m_gameStream.flush();
	if (m_isVersion5) {
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength));
	} else {
		m_gameData.reset(new BlockFile(&m_gameStream, m_blockSize, BlockFile::RequireLength, m_magicGameFile));
		m_hasMagic = true;
		writeNamebases(namebaseStream);
		writeIndexHeader(indexStream);
	}
}


void
Codec::save(mstl::string const& rootname, unsigned start, Progress& progress, bool attach)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	if (!(m_gameStream.mode() & mstl::ios_base::out))
		IO_RAISE(Game, Read_Only, "game file '%s' is read-only", (rootname + m_extGame).c_str());

	mstl::string indexFilename(rootname + m_extIndex);
	if (!attach)
		checkPermissions(indexFilename);

	if (isReadonly())
		IO_RAISE(Index, Read_Only, "index file '%s' is read-only", indexFilename.c_str());

	mstl::string namebaseFilename(rootname + m_extNamebase);
	if (!attach)
		checkPermissions(namebaseFilename);

	if (isReadonly())
		IO_RAISE(Namebase, Read_Only, "name-base file '%s' is read-only", namebaseFilename.c_str());

	m_gameData->sync();

	mstl::fstream indexStream;
	if (m_isVersion5) {
		openFile(indexStream, indexFilename, attach ? Truncate : 0);
	} else {
		openFile(indexStream, indexFilename, MagicIndexFile, attach ? Truncate : 0);
	}

	writeNamebases(namebaseFilename);
	writeIndexEntries(indexStream, start, progress);
}


void
Codec::save(mstl::string const& rootname, unsigned start, Progress& progress)
{
	save(rootname, start, progress, false);
}


void
Codec::attach(mstl::string const& rootname, Progress& progress)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	static mstl::ios_base::openmode mode =
		mstl::ios_base::in | mstl::ios_base::out | mstl::ios_base::trunc | mstl::ios_base::binary;

	mstl::string gameFilename(rootname + m_extGame);
	m_gameStream.set_unbuffered();
	m_gameStream.open(sys::file::internalName(gameFilename), mode);
	progress.message("read-game");
	m_gameData->attach(&m_gameStream, &progress);
	save(rootname, 0, progress, true);
}


void
Codec::update(mstl::string const& rootname)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	if (!(m_gameStream.mode() & mstl::ios_base::out))
		IO_RAISE(Game, Read_Only, "game file '%s' is read-only", (rootname + ".gi3").c_str());

	mstl::string indexFilename(rootname + m_extIndex);
	checkPermissions(indexFilename);

	if (isReadonly())
		IO_RAISE(Index, Read_Only, "index file '%s' is read-only", indexFilename.c_str());

	mstl::string namebaseFilename(rootname + m_extNamebase);
	checkPermissions(namebaseFilename);

	if (isReadonly())
		IO_RAISE(Namebase, Read_Only, "name-base file '%s' is read-only", namebaseFilename.c_str());

	m_gameData->sync();

	mstl::fstream indexStream;
	indexStream.open(	sys::file::internalName(indexFilename),
							mstl::ios_base::in | mstl::ios_base::out | mstl::ios_base::binary);

	writeNamebases(namebaseFilename);
	updateIndex(indexStream);
}


void
Codec::update(mstl::string const& rootname, unsigned index, bool updateNamebase)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	if (!(m_gameStream.mode() & mstl::ios_base::out))
		IO_RAISE(Game, Read_Only, "game file '%s' is read-only", (rootname + m_extGame).c_str());

	mstl::string indexFilename(rootname + m_extIndex);
	checkPermissions(indexFilename);

	if (isReadonly())
		IO_RAISE(Index, Read_Only, "index file '%s' is read-only", indexFilename.c_str());

	mstl::fstream indexStream;

	m_gameData->sync();
	indexStream.open(	sys::file::internalName(indexFilename),
							mstl::ios_base::in | mstl::ios_base::out | mstl::ios_base::binary);

	if (updateNamebase)
	{
		mstl::string namebaseFilename(rootname + m_extNamebase);
		checkPermissions(namebaseFilename);
		writeNamebases(namebaseFilename);
	}

	unsigned char buf[m_indexEntrySize];
	ByteStream bstrm(buf, m_indexEntrySize);
	encodeIndex(gameInfoList()[index], index, bstrm);

	if (!indexStream.seekp(index*m_indexEntrySize + (m_isVersion5 ? 0u : m_headerSize + 8u)))
		IO_RAISE(Index, Corrupted, "unexpected end of index file");
	if (!indexStream.write(buf, m_indexEntrySize))
		IO_RAISE(Index, Write_Failed, "error while writing index entry");
}


void
Codec::updateHeader(mstl::string const& rootname)
{
	mstl::string indexFilename(rootname + m_extIndex);
	checkPermissions(indexFilename);

	if (isReadonly())
		IO_RAISE(Index, Read_Only, "index file '%s' is read-only", indexFilename.c_str());

	mstl::fstream indexStream;
	indexStream.open(	sys::file::internalName(indexFilename),
							mstl::ios_base::in | mstl::ios_base::out | mstl::ios_base::binary);
	writeIndexHeader(indexStream);
}


void
Codec::writeIndexHeader(mstl::fstream& fstrm)
{
	if (m_isVersion5) return; // si5 has no index header

	// write header (w/o magic)
	unsigned char header[MaxIndexHeaderSize];
	ByteStream strm(header, m_headerSize);

	::memset(header, 0, m_headerSize);
	if (m_customFlags)
		::memcpy(header + 120, m_customFlags, sizeof(CustomFlags));

	unsigned autoLoad = m_autoLoad;

	if (autoLoad == 0 || autoLoad > gameInfoList().size() + 1)
		autoLoad = gameInfoList().empty() ? 1 : 2;

	strm << uint16_t(m_fileVersion);						// Scid version
	strm << uint32_t(Encoder::encodeType(type()));	// base type
	strm << uint24_t(gameInfoList().size());			// number of games
	strm << uint24_t(autoLoad);							// auto load

	strm.put(description(),
				mstl::min(	description().size(),
								mstl::string::size_type(119 - strm.tellp())));

	if (!fstrm.seekp(8, mstl::ios_base::beg))	// skip magic
		IO_RAISE(Index, Corrupted, "unexpected end of index file");

	if (!fstrm.write(header, m_headerSize))
		IO_RAISE(Index, Write_Failed, "error while writing index entry");
}


void
Codec::writeIndexEntries(mstl::fstream& fstrm, unsigned start, Progress& progress)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	writeIndexHeader(fstrm);

	if (start > 0 && !fstrm.seekp(start*m_indexEntrySize, mstl::ios_base::cur))
		IO_RAISE(Index, Corrupted, "cannot seek to end of index file");

	GameInfoList& infoList = gameInfoList();

	unsigned frequency	= progress.frequency(infoList.size(), 5000);
	unsigned reportAfter	= frequency + start;

	ProgressWatcher watcher(progress, infoList.size());
	progress.message("write-index");

	for (unsigned i = start; i < infoList.size(); ++i)
	{
		if (reportAfter == i)
		{
			progress.update(i);
			reportAfter += frequency;
		}

		char buf[MaxIndexEntrySize];

		ByteStream bstrm(buf, m_indexEntrySize);
		encodeIndex(infoList[i], i, bstrm);

		if (__builtin_expect(!fstrm.write(buf, m_indexEntrySize), 0))
			IO_RAISE(Index, Write_Failed, "error while writing index entry");
	}
}


void
Codec::updateIndex(mstl::fstream& fstrm)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	// update header (si5 has no file header, skip)
	if (!m_isVersion5)
	{
		if (!fstrm.seekp(14))
			IO_RAISE(Index, Corrupted, "unexpected end of file");

		unsigned char buf[6];
		ByteStream strm(buf, sizeof(buf));

		strm << uint24_t(gameInfoList().size());				// number of games
		strm << uint24_t(gameInfoList().empty() ? 1 : 2);	// auto load

		if (!fstrm.write(buf, sizeof(buf)))
			IO_RAISE(Index, Write_Failed, "error while writing index entry");
	}

	GameInfoList& infoList = gameInfoList();

	for (unsigned i = 0; i < infoList.size(); ++i)
	{
		GameInfo& info = infoList[i];

		if (info.isDirty())
		{
			unsigned char buf[MaxIndexEntrySize];

			ByteStream bstrm(buf, m_indexEntrySize);
			encodeIndex(info, i, bstrm);

			unsigned offset = i*m_indexEntrySize + (m_isVersion5 ? 0u : m_headerSize + 8u);
			if (!fstrm.seekp(offset))
				IO_RAISE(Index, Corrupted, "unexpected end of file");
			if (!fstrm.write(buf, m_indexEntrySize))
				IO_RAISE(Index, Write_Failed, "error while writing index entry");

			info.setDirty(false);
		}
	}
}


void
Codec::encodeIndex(GameInfo const& item, unsigned index, ByteStream& buf)
{
	if (m_isVersion5) { encodeIndexSi5(item, index, buf); return; }

	M_ASSERT(item.gameRecordLength() <= maxGameRecordLength());

	static_assert(GameInfo::Flag_Deleted == 1 <<  0, "GameInfo flags have changed");
	static_assert(GameInfo::Flag_User1   == 1 << 13, "GameInfo flags have changed");
	static_assert(GameInfo::Flag_User6   == 1 << 18, "GameInfo flags have changed");

	uint16_t flags = (item.m_gameFlags & ((1 << 13) - 1)) << 3;

	if (!item.hasStandardPosition(variant::Normal))
		flags |= flags::Non_Standard_Start;
	if (item.hasPromotion())
		flags |= flags::Promotion;
	if (item.hasUnderPromotion())
		flags |= flags::Under_Promotion;

	uint32_t gameRecordLength = item.gameRecordLength();

	M_ASSERT(gameRecordLength > 0);

	// length of each gamefile record and its offset
	buf << uint32_t(item.m_gameOffset);
	buf << uint16_t(gameRecordLength);
	if (m_customFlags)
		buf << uint8_t(((gameRecordLength >> 16) << 7) | ((item.m_gameFlags >> 13) & 0x3f));
	buf << uint16_t(flags);

	// White and Black player names
	unsigned whiteId = m_playerList->lookup(item.m_player[color::White]->id())->id;
	unsigned blackId = m_playerList->lookup(item.m_player[color::Black]->id())->id;

	buf << uint8_t((((whiteId >> 16) & 0xf) << 4) | (((blackId >> 16) & 0xf)));
	buf << uint16_t(whiteId);
	buf << uint16_t(blackId);

	// Event, Site and Round names
	unsigned eventId	= m_eventList->lookup(item.m_event->id())->id;
	unsigned siteId	= m_siteList->lookup(item.m_event->site()->id())->id;
	unsigned roundId	= m_roundList->lookup(m_roundLookup[index]->id())->id;

	buf << uint8_t(	uint8_t((eventId >> 16) << 5)
						 | uint8_t(((siteId >> 16) & 7) << 2)
						 | uint8_t((roundId >> 16) & 3));
	buf << uint16_t(eventId);
	buf << uint16_t(siteId);
	buf << uint16_t(roundId);

	buf << uint16_t(	uint16_t(item.m_variationCount)
						 | uint16_t(item.m_commentCount << 4)
						 | uint16_t(item.m_annotationCount << 8)
						 | uint16_t((item.m_result & 0x03) << 12));

	buf << uint16_t(item.m_eco ? (item.m_eco - 1)*131 + 1 : 0);

	uint32_t dateYear = Date::decodeYearFrom10Bits(item.m_dateYear);

	if (dateYear && dateYear <= 2047)
	{
		// Date and EventDate are stored in four bytes
		uint32_t date				= (dateYear << 9) | (item.m_dateMonth << 5) | item.m_dateDay;
		uint32_t eventDateYear	= item.m_event->dateYear();

		if (eventDateYear && eventDateYear <= 2047 && mstl::abs(int(eventDateYear) - int(dateYear)) <= 3)
		{
			buf << uint32_t(	date
								 | ((uint32_t(eventDateYear + 4 - dateYear)) << 29)
								 | (uint32_t(item.m_event->dateMonth()) << 25)
								 | (uint32_t(item.m_event->dateDay()) << 20));
		}
		else
		{
			buf << date;
		}
	}
	else
	{
		buf << uint32_t(0);
	}

	// The two Elo ratings and rating types take 2 bytes each
	if (item.m_pd[color::White].elo)
	{
		buf << uint16_t(mstl::min(uint16_t(4000), uint16_t(item.m_pd[color::White].elo)));
	}
	else if (item.m_pd[color::White].ratingType <= 6)
	{
		buf << uint16_t(	mstl::min(uint16_t(4000), uint16_t(item.m_pd[color::White].rating))
							 | uint32_t(item.m_pd[color::White].ratingType << 12));
	}
	else
	{
		buf << uint16_t(0);
	}

	if (item.m_pd[color::Black].elo)
	{
		buf << uint16_t(mstl::min(uint16_t(4000), uint16_t(item.m_pd[color::Black].elo)));
	}
	else if (item.m_pd[color::Black].ratingType <= 6)
	{
		buf << uint16_t(	mstl::min(uint16_t(4000), uint16_t(item.m_pd[color::Black].rating))
							 | uint16_t(item.m_pd[color::Black].ratingType << 12));
	}
	else
	{
		buf << uint16_t(0);
	}

	uint8_t storedLineIndex;

	if (item.idn() == variant::Standard)
		storedLineIndex = StoredLine::lookup(Eco(item.m_ecoKey)).index();
	else
		storedLineIndex = 0;

	M_ASSERT(storedLineIndex < 255);

	// what will happen if item.m_numHalfMoves succeeds 1023?
	unsigned plyCount = mstl::min(unsigned(item.m_plyCount), 0x03ffu);

	buf << storedLineIndex;
	buf << uint24_t(item.material().value);
	buf << uint8_t(plyCount);

	// the first byte of HomePawnData has high bits of the NumHalfMoves counter in its top two bits
	buf << uint8_t(item.m_signature.hpCount() | ((plyCount >> 8) << 6));

	hp::Pawns hp = item.m_signature.homePawnsData();
	::swapHomePawnBytes(hp.bytes);
	buf.put(hp.bytes, 8);
}


uint16_t
Codec::readIndexHeader(mstl::fstream& fstrm, unsigned* retNumGames)
{
	char header[MaxIndexHeaderSize];

	if (!fstrm.read(header, m_headerSize))
		IO_RAISE(Index, Corrupted, "unexpected end of file");
	if (m_customFlags)
		::memcpy(m_customFlags, header + 120, sizeof(CustomFlags));

	ByteStream bstrm(header, m_headerSize);

	uint16_t version = bstrm.uint16();

	if (version == 500 && !m_isVersion5) {
		m_isVersion5 = true;
		const_cast<Codec*>(this)->m_fileVersion = 500;
		const_cast<Codec*>(this)->m_indexEntrySize = 56;
	}
	if (version != m_fileVersion)
		IO_RAISE(Index, Unknown_Version, "unsupported Scid version (%u)", unsigned(version));

	setType(Decoder::decodeType(bstrm.uint32()));

	GameInfoList& infoList = gameInfoList();
	unsigned numGames = bstrm.uint24();
	infoList.resize(retNumGames ? 1 : numGames);
	if (retNumGames)
		*retNumGames = numGames;

	m_autoLoad = bstrm.uint24();

	mstl::string description;
	bstrm[119] = '\0';	// to be sure
	getRecodedDescription(reinterpret_cast<char const*>(bstrm.data()), description, *m_codec);
	setDescription(description);

	setVariant(variant::Normal);

	return version;
}


void
Codec::readIndex(mstl::fstream& fstrm, util::Progress& progress)
{
	if (!m_isVersion5) {
		uint16_t version = readIndexHeader(fstrm, 0);
		if (version != m_fileVersion)
			IO_RAISE(Index, Unknown_Version, "unsupported Scid version (%u)", unsigned(version));
	} else {
		// si5 has no file header - set defaults manually
		setVariant(variant::Normal);
		setType(type::Unspecific);
	}

	decodeIndex(fstrm, progress);
	fstrm.close();
}


void
Codec::getRecodedDescription(char const* description, mstl::string& result, sys::utf8::Codec& codec)
{
	mstl::string str(const_cast<char*>(description));
	codec.toUtf8(str, result);

	if (!sys::utf8::validate(result))
	{
		// the database is opened with wrong encoding
		codec.forceValidUtf8(result);
	}
}


void
Codec::decodeIndex(mstl::fstream &fstrm, util::Progress& progress)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	GameInfoList& infoList = gameInfoList();

	if (m_isVersion5 && infoList.size() == 0) {
		long fileSize = fstrm.size();
		if (fileSize > 0)
			infoList.resize(static_cast<unsigned>(fileSize / m_indexEntrySize));
	}

	m_roundLookup.resize(infoList.size());

	unsigned frequency	= progress.frequency(infoList.size(), 20000);
	unsigned reportAfter	= frequency;

	ProgressWatcher watcher(progress, infoList.size());
	progress.message("read-index");

	for (unsigned i = 0; i < infoList.size(); ++i)
	{
		if (reportAfter == i)
		{
			progress.update(i);
			reportAfter += frequency;
		}

		char buf[MaxIndexEntrySize];

		if (__builtin_expect(!fstrm.read(buf, m_indexEntrySize), 0))
			IO_RAISE(Index, Corrupted, "unexpected end of file");

		ByteStream bstrm(buf, m_indexEntrySize);
		decodeIndex(bstrm, i);
	}
}


void
Codec::readIndexProgressive(unsigned index)
{
	M_ASSERT(m_progressiveStream);

	char buf[MaxIndexEntrySize];

	if (!m_progressiveStream->seekg(index*m_indexEntrySize + m_headerSize + 8, mstl::ios_base::beg))
		IO_RAISE(Index, Corrupted, "seek failed");

	if (__builtin_expect(!m_progressiveStream->read(buf, m_indexEntrySize), 0))
		IO_RAISE(Index, Corrupted, "unexpected end of index file");

	ByteStream bstrm(buf, m_indexEntrySize);
	decodeIndex(bstrm, 0);
}


void
Codec::decodeIndexSi5(ByteStream& strm, unsigned index)
{
	struct Pair { uint32_t hi, lo; };
	auto decode_uint32 = [](const unsigned char* p) -> uint32_t {
		return uint32_t(p[0]) | (uint32_t(p[1])<<8) | (uint32_t(p[2])<<16) | (uint32_t(p[3])<<24);
	};
	auto unpack = [](uint32_t val, int sz) -> Pair {
		return { val >> (32 - sz), (val << sz) >> sz };
	};

	unsigned char buf[56];
	strm.get(reinterpret_cast<Byte*>(buf), 56);
	GameInfo& item = gameInfo(index);

	Pair p0  = unpack(decode_uint32(buf+ 0),  4); uint32_t nComments=p0.hi,  whiteID   =p0.lo;
	Pair p4  = unpack(decode_uint32(buf+ 4),  4); uint32_t nVars    =p4.hi,  blackID   =p4.lo;
	Pair p8  = unpack(decode_uint32(buf+ 8),  4); uint32_t nNags    =p8.hi,  eventID   =p8.lo;
	uint32_t siteID = decode_uint32(buf+12);
	Pair p16 = unpack(decode_uint32(buf+16),  1); uint32_t roundID  =p16.lo;
	Pair p20 = unpack(decode_uint32(buf+20), 12); uint32_t whiteElo =p20.hi, dateEnc   =p20.lo;
	Pair p24 = unpack(decode_uint32(buf+24), 12); uint32_t blackElo =p24.hi; (void)p24.lo;
	Pair p28 = unpack(decode_uint32(buf+28), 10); uint32_t halfMoves=p28.hi, flags     =p28.lo;
	Pair p32 = unpack(decode_uint32(buf+32), 17); uint32_t gameLen  =p32.hi, offsetHigh=p32.lo;
	uint32_t offsetLow = decode_uint32(buf+36);
	Pair p40 = unpack(decode_uint32(buf+40),  8); uint32_t storedLine=p40.hi, finalMat =p40.lo;
	Pair p44 = unpack(decode_uint32(buf+44), 16); uint32_t highWord =p44.hi, ecoCode   =p44.lo;

	uint32_t homePawnCount      = highWord >> 8;
	uint32_t whiteRatingTypeSi5 = (highWord >> 5) & 0x7;
	uint32_t blackRatingTypeSi5 = (highWord >> 2) & 0x7;
	uint32_t result             = highWord & 0x3;

	// Clamp invalid IDs (deleted/empty games have out-of-range IDs in si5)
	unsigned maxPlayerID = m_playerList->size() ? m_playerList->size()-1 : 0;
	unsigned maxEventID  = m_eventList->size()  ? m_eventList->size()-1  : 0;
	unsigned maxSiteID   = m_siteList->size()   ? m_siteList->size()-1   : 0;
	unsigned maxRoundID  = m_roundList->size()  ? m_roundList->size()-1  : 0;
	::fprintf(stderr, "SI5-DEBUG game[%u]: white=%u black=%u event=%u site=%u round=%u"
	          " | maxP=%u maxE=%u maxS=%u maxR=%u\n",
	          index, whiteID, blackID, eventID, siteID, roundID,
	          maxPlayerID, maxEventID, maxSiteID, maxRoundID);
	if (whiteID > maxPlayerID) whiteID = 0;
	if (blackID > maxPlayerID) blackID = 0;
	if (eventID > maxEventID)  eventID = 0;
	if (siteID  > maxSiteID)   siteID  = 0;
	if (roundID > maxRoundID)  roundID = 0;
	NamebasePlayer* whitePlayer =
		::check(static_cast<NamebasePlayer*>(m_playerList->lookup(whiteID)->entry));
	NamebasePlayer* blackPlayer =
		::check(static_cast<NamebasePlayer*>(m_playerList->lookup(blackID)->entry));
	whitePlayer->incrRef(); blackPlayer->incrRef();
	item.m_player[color::White] = whitePlayer;
	item.m_player[color::Black] = blackPlayer;

	NamebaseEvent* event = ::check(static_cast<NamebaseEvent*>(m_eventList->lookup(eventID)->entry));
	NamebaseSite*  site  = ::check(static_cast<NamebaseSite* >(m_siteList->lookup(siteID)->entry));
	NamebaseEntry* round = ::check(static_cast<NamebaseEntry*>(m_roundList->lookup(roundID)->entry));

	m_roundLookup[index] = round;
	unsigned rnd, subrnd;
	if (Reader::parseRound(round->name(), rnd, subrnd)) {
		item.m_round = rnd; item.m_subround = subrnd;
	}
	if (event->site() == this->namebase(Namebase::Site).emptySite()) {
		event->setSite_(site);
		event->setDate_(Date());
		event->setEventMode_(Reader::getEventMode(event->name(), site->name()));
	}
	round->incrRef(); event->incrRef();
	item.m_event = event;

	item.m_gameOffset = (uint64_t(offsetHigh) << 32) | offsetLow;
	item.setGameRecordLength(gameLen);
	item.m_gameFlags  = flags >> 3;
	item.m_positionId = (flags & flags::Non_Standard_Start) ? 0 : variant::Standard;
	item.m_setup      = bool(flags & flags::Non_Standard_Start);
	// Note: chess960 bit ignored for now (Chess960 IDN not stored in si5 index)
	item.m_result     = result;

	{ Date date;
	  date.setYMD((dateEnc >> 9) & 2047, (dateEnc >> 5) & 15, dateEnc & 31);
	  item.m_dateYear = Date::encodeYearTo10Bits(date.year());
	  item.m_dateMonth = date.month(); item.m_dateDay = date.day(); }

	item.m_eco      = ecoCode ? (ecoCode - 1)/131 + 1 : 0;
	item.m_plyCount = halfMoves;

	// si5 rating: if rating value is 0, type must be Elo (Scidb invariant)
	// Assertion: (pd.rating==0) == (pd.ratingType==Elo)
	// -> if no rating value, always use Elo type
	rating::Type wrt = (whiteElo == 0) ? rating::Elo
	                 : rating::Type(whiteRatingTypeSi5 < 8 ? whiteRatingTypeSi5 : 0);
	rating::Type brt = (blackElo == 0) ? rating::Elo
	                 : rating::Type(blackRatingTypeSi5 < 8 ? blackRatingTypeSi5 : 0);
	item.m_pd[color::White].ratingType = wrt;
	item.m_pd[color::Black].ratingType = brt;
	if (wrt == rating::Elo) item.m_player[color::White]->setElo(item.m_pd[color::White].elo = rating::clip(whiteElo));
	else item.m_player[color::White]->setRating(wrt, item.m_pd[color::White].rating = rating::clip(whiteElo));
	if (brt == rating::Elo) item.m_player[color::Black]->setElo(item.m_pd[color::Black].elo = rating::clip(blackElo));
	else item.m_player[color::Black]->setRating(brt, item.m_pd[color::Black].rating = rating::clip(blackElo));

	if (item.m_positionId == variant::Standard && storedLine < StoredLine::count())
		item.m_ecoKey = StoredLine::getLine(storedLine).ecoKey();

	item.setMaterial(material::si3::Signature(finalMat));
	item.m_plyCount = halfMoves;

	hp::Pawns hp;
	::memcpy(hp.bytes, buf+48, 8);
	::swapHomePawnBytes(hp.bytes);
	unsigned count = homePawnCount & 63;
	::memset(hp.bytes + mstl::div2(count+1), 0, mstl::div2(16-count));
	if (mstl::is_odd(count)) hp.bytes[mstl::div2(count)] &= 0x0f;
	item.m_signature.setHomePawns(count, hp);
	item.m_signature.m_promotions      = !!(flags & flags::Promotion);
	item.m_signature.m_underPromotions = !!(flags & flags::Under_Promotion);
	item.m_signature.m_castling        = 0;
	item.m_variationCount  = nVars     & 15;
	item.m_commentCount    = nComments & 15;
	item.m_annotationCount = nNags     & 15;
}


void
Codec::encodeIndexSi5(GameInfo const& item, unsigned index, ByteStream& buf)
{
	// Encode 56-byte si5 index entry (inverse of decodeIndexSi5)
	// Layout: 12 x uint32 little-endian + 8 bytes HomePawn

	auto encode_uint32 = [](unsigned char* p, uint32_t v) {
		p[0] = v & 0xFF; p[1] = (v>>8)&0xFF; p[2] = (v>>16)&0xFF; p[3] = (v>>24)&0xFF;
	};
	auto pack = [](uint32_t hi, uint32_t lo, int sz) -> uint32_t {
		return (hi << (32-sz)) | (lo & ((1u<<(32-sz))-1));
	};

	unsigned char out[56];
	::memset(out, 0, 56);

	// Use namebase insertion-order IDs directly; writeNamebasesSi5 writes in the same order.
	uint32_t whiteID  = item.m_player[color::White]->id();
	uint32_t blackID  = item.m_player[color::Black]->id();
	uint32_t eventID  = item.m_event->id();
	uint32_t siteID   = item.m_event->site()->id();
	uint32_t roundID  = m_roundLookup[index]->id();

	// Flags
	uint32_t flags = (item.m_gameFlags << 3);
	if (!item.hasStandardPosition(variant::Normal)) flags |= flags::Non_Standard_Start;
	if (item.hasPromotion())                         flags |= flags::Promotion;
	if (item.hasUnderPromotion())                    flags |= flags::Under_Promotion;

	// Date
	uint32_t dateYear = Date::decodeYearFrom10Bits(item.m_dateYear);
	uint32_t dateEnc  = (dateYear <= 2047 && dateYear > 0)
	                  ? ((dateYear<<9)|(item.m_dateMonth<<5)|item.m_dateDay) : 0;

	// Ratings
	uint32_t whiteElo = 0, blackElo = 0;
	uint32_t wRatingType = 0, bRatingType = 0;
	if (item.m_pd[color::White].elo) {
		whiteElo = mstl::min(4000u, (unsigned)item.m_pd[color::White].elo);
		wRatingType = rating::Elo;
	} else if (item.m_pd[color::White].rating) {
		whiteElo = mstl::min(4000u, (unsigned)item.m_pd[color::White].rating);
		wRatingType = item.m_pd[color::White].ratingType;
	}
	if (item.m_pd[color::Black].elo) {
		blackElo = mstl::min(4000u, (unsigned)item.m_pd[color::Black].elo);
		bRatingType = rating::Elo;
	} else if (item.m_pd[color::Black].rating) {
		blackElo = mstl::min(4000u, (unsigned)item.m_pd[color::Black].rating);
		bRatingType = item.m_pd[color::Black].ratingType;
	}

	// ECO
	uint32_t ecoCode = item.m_eco ? (item.m_eco - 1)*131 + 1 : 0;

	// Stored line
	uint32_t storedLine = 0;
	if (item.idn() == variant::Standard)
		storedLine = StoredLine::lookup(Eco(item.m_ecoKey)).index();

	// Half moves
	uint32_t halfMoves = mstl::min(unsigned(item.m_plyCount), 0x3FFu);

	// Game offset and length
	uint32_t offsetLow  = static_cast<uint32_t>(item.m_gameOffset & 0xFFFFFFFF);
	uint32_t offsetHigh = static_cast<uint32_t>(item.m_gameOffset >> 32) & 0x7FFF;
	uint32_t gameLen    = item.gameRecordLength() & 0x1FFFF;

	// HomePawns
	hp::Pawns hp = item.m_signature.homePawnsData();
	unsigned hpCount = item.m_signature.hpCount();

	// buf[44..47]: highWord = (homePawnCount<<8 | wRatingType<<5 | bRatingType<<2 | result)
	uint32_t highWord = (hpCount << 8) | ((wRatingType & 7) << 5) | ((bRatingType & 7) << 2) | (item.m_result & 3);

	// Pack all fields
	encode_uint32(out+ 0, pack(uint32_t(item.m_commentCount  & 15), whiteID,   4));
	encode_uint32(out+ 4, pack(uint32_t(item.m_variationCount& 15), blackID,   4));
	encode_uint32(out+ 8, pack(uint32_t(item.m_annotationCount&15), eventID,   4));
	encode_uint32(out+12, siteID);
	encode_uint32(out+16, pack(0, roundID, 1));  // chess960 bit = 0
	encode_uint32(out+20, pack(whiteElo,  dateEnc,  12));
	encode_uint32(out+24, pack(blackElo,  0,         12));
	encode_uint32(out+28, pack(halfMoves, flags,     10));
	encode_uint32(out+32, pack(gameLen,   offsetHigh,17));
	encode_uint32(out+36, offsetLow);
	encode_uint32(out+40, pack(storedLine, item.material().value, 8));
	encode_uint32(out+44, pack(highWord, ecoCode, 16));

	// HomePawn data (8 bytes)
	::swapHomePawnBytes(hp.bytes);
	::memcpy(out+48, hp.bytes, 8);

	buf.put(reinterpret_cast<char*>(out), 56);
}


void
Codec::writeNamebasesSi5(mstl::string const& filename)
{
	// si5 namebase format: [varint: length*8+type][string]
	// type: 0=PLAYER 1=EVENT 2=SITE 3=ROUND

	mstl::string tempname(filename + ".temp.38583276");
	try {
		mstl::fstream fstrm(sys::file::internalName(tempname),
		                    mstl::ios_base::out | mstl::ios_base::binary | mstl::ios_base::trunc);
		if (!fstrm) IO_RAISE(Namebase, Open_Failed, "cannot create si5 namebase");
		fstrm.set_bufsize(65536);

		auto writeVarint = [&](uint64_t val) {
			while (val >= 128) {
				fstrm.put(static_cast<char>((val & 0x7F) | 0x80));
				val >>= 7;
			}
			fstrm.put(static_cast<char>(val));
		};
		auto writeEntry = [&](mstl::string const& name, unsigned type) {
			// Empty names must be written as "?" to match buildList() which substitutes
			// "?" for empty entries; readNamebasesSi5 skips len==0 entries, causing
			// ID mismatches that trigger m_lookup[id]==null assertions on re-open.
			char const* s = name.empty() ? "?" : name.c_str();
			size_t len = name.empty() ? 1 : name.size();
			uint64_t hdr = (static_cast<uint64_t>(len) << 3) | type;
			writeVarint(hdr);
			fstrm.write(s, len);
		};

		m_playerList->update(namebase(Namebase::Player), *m_codec);
		m_eventList ->update(namebase(Namebase::Event ), *m_codec);
		m_siteList  ->update(namebase(Namebase::Site  ), *m_codec);
		m_roundList ->update(namebase(Namebase::Round ), *m_codec);

		// Write in ID order (si5 IDs are sequential)
		Namebase& pBase = namebase(Namebase::Player);
		mstl::vector<mstl::string> players(pBase.size());
		for (unsigned i = 0; i < pBase.size(); ++i)
			players[pBase.playerAt(i)->id()] = pBase.playerAt(i)->name();
		for (unsigned i = 0; i < players.size(); ++i)
			writeEntry(players[i], 0);

		Namebase& eBase = namebase(Namebase::Event);
		mstl::vector<mstl::string> events(eBase.size());
		for (unsigned i = 0; i < eBase.size(); ++i)
			events[eBase.eventAt(i)->id()] = eBase.eventAt(i)->name();
		for (unsigned i = 0; i < events.size(); ++i)
			writeEntry(events[i], 1);

		Namebase& sBase = namebase(Namebase::Site);
		mstl::vector<mstl::string> sites(sBase.size());
		for (unsigned i = 0; i < sBase.size(); ++i)
			sites[sBase.siteAt(i)->id()] = sBase.siteAt(i)->name();
		for (unsigned i = 0; i < sites.size(); ++i)
			writeEntry(sites[i], 2);

		Namebase& rBase = namebase(Namebase::Round);
		mstl::vector<mstl::string> rounds(rBase.size());
		for (unsigned i = 0; i < rBase.size(); ++i)
			rounds[rBase.entryAt(i)->id()] = rBase.entryAt(i)->name();
		for (unsigned i = 0; i < rounds.size(); ++i)
			writeEntry(rounds[i], 3);

		fstrm.flush();
		sys::file::rename(tempname, filename, true);
		namebases().setModified(false);
	} catch (...) {
		sys::file::deleteIt(tempname);
		throw;
	}
}


void
Codec::readNamebasesSi5(mstl::string const& filename, util::Progress& progress)
{
	// si5 namebase format (codec_scid5.h):
	// [varint: length*8+type][string]
	// type: 0=PLAYER 1=EVENT 2=SITE 3=ROUND 4=DB_INFO
	// IDs sequential from 0 per type, NOT necessarily sorted by name.

	mstl::fstream fstrm(sys::file::internalName(filename),
	                    mstl::ios_base::in | mstl::ios_base::binary);
	if (!fstrm) IO_RAISE(Namebase, Open_Failed, "cannot open si5 namebase");
	fstrm.set_bufsize(65536);

	// Step 1: Read all names with their original si5 IDs
	typedef mstl::pair<unsigned,mstl::string> IdName;
	mstl::vector<IdName> players, events, sites, rounds;
	char buf[4096];
	int ch;
	unsigned typeCounts[4] = {0,0,0,0};

	while ((ch = fstrm.get()) != EOF) {
		uint64_t res=0; int shift=0;
		uint8_t bval = static_cast<uint8_t>(ch);
		while (true) {
			res |= (static_cast<uint64_t>(bval & 0x7F) << shift);
			if (bval < 128) break;
			shift += 7;
			int nxt = fstrm.get();
			if (nxt == EOF) break;
			bval = static_cast<uint8_t>(nxt);
		}
		uint8_t  nt  = static_cast<uint8_t>(res & 0x7);
		uint64_t len = res >> 3;
		if (len == 0 || len >= sizeof(buf)) {
			for (uint64_t i=0; i<len; ++i) if (fstrm.get()==EOF) break;
			continue;
		}
		fstrm.read(buf, static_cast<size_t>(len));
		if (fstrm.fail()) break;
		buf[len] = '\0';
		mstl::string name(buf, static_cast<unsigned>(len));
		unsigned id = (nt < 4) ? typeCounts[nt]++ : 0;
		switch (nt) {
			case 0: players.push_back(IdName(id,name)); break;
			case 1: events.push_back(IdName(id,name));  break;
			case 2: sites.push_back(IdName(id,name));   break;
			case 3: rounds.push_back(IdName(id,name));  break;
		}
	}

	// Step 2: Insert into Namebase (this sorts internally).
	// We pass the si5 ID so entry->m_id = si5_id.
	m_playerList->reserve(players.size()+1);
	m_eventList->reserve(events.size()+1);
	m_siteList->reserve(sites.size()+1);
	m_roundList->reserve(rounds.size()+1);

	for (unsigned i=0; i<players.size(); ++i) {
		mstl::string& name=players[i].second;
		namebase(Namebase::Player).insertPlayer(
			name,players[i].first,country::Unknown,title::None,
			species::Unspecified,sex::Unspecified,0,maxPlayerCount());
	}
	for (unsigned i=0; i<events.size(); ++i) {
		mstl::string& name=events[i].second;
		namebase(Namebase::Event).insertEvent(
			name,events[i].first,maxEventCount(),
			namebase(Namebase::Site).emptySite());
	}
	for (unsigned i=0; i<sites.size(); ++i) {
		mstl::string& name=sites[i].second;
		mstl::string tmp(name);
		country::Code country=Reader::extractCountryFromSite(tmp);
		namebase(Namebase::Site).insertSite(name,sites[i].first,country,maxSiteCount());
	}
	for (unsigned i=0; i<rounds.size(); ++i) {
		mstl::string& name=rounds[i].second;
		namebase(Namebase::Round).insert(name,rounds[i].first,::MaxRoundCount);
	}

	// Step 3: Build NameList lookup by iterating over the sorted Namebase.
	// entry->id() == si5_id (set by insertXxx above).
	// append(name, entry->id(), entry, codec) sets m_lookup[entry->id()] correctly.
	Namebase& pBase = namebase(Namebase::Player);

	for (unsigned i=0; i<pBase.size(); ++i) {
		NamebasePlayer* e = pBase.playerAt(i);
		m_playerList->append(e->name(), e->id(), e, *m_codec);
	}
	Namebase& eBase = namebase(Namebase::Event);
	for (unsigned i=0; i<eBase.size(); ++i) {
		NamebaseEvent* e = eBase.eventAt(i);
		m_eventList->append(e->name(), e->id(), e, *m_codec);
	}
	Namebase& sBase = namebase(Namebase::Site);
	for (unsigned i=0; i<sBase.size(); ++i) {
		NamebaseSite* e = sBase.siteAt(i);
		m_siteList->append(e->name(), e->id(), e, *m_codec);
	}
	Namebase& rBase = namebase(Namebase::Round);
	for (unsigned i=0; i<rBase.size(); ++i) {
		NamebaseEntry* e = rBase.entryAt(i);
		m_roundList->append(e->name(), e->id(), e, *m_codec);
	}

	m_playerList->finish(); m_eventList->finish();
	m_siteList->finish();   m_roundList->finish();
	namebases().setModified(false);
}


void
Codec::decodeIndex(ByteStream& strm, unsigned index)
{
	if (m_isVersion5) { decodeIndexSi5(strm, index); return; }


	static_assert(GameInfo::Flag_Deleted == 1 <<  0, "GameInfo flags have changed");
	static_assert(GameInfo::Flag_User1   == 1 << 13, "GameInfo flags have changed");
	static_assert(GameInfo::Flag_User6   == 1 << 18, "GameInfo flags have changed");

	GameInfo& item = gameInfo(index);

	uint32_t flags;
	uint32_t gameRecordLength;

	// length of each gamefile record and its offset
	item.m_gameOffset = strm.uint32();
	gameRecordLength = strm.uint16();

	if (m_customFlags)
	{
		uint32_t byte = strm.uint8();

		gameRecordLength |= uint32_t(byte & 0x80) << 9;
		flags = strm.uint16() | ((byte & 0x3f) << 16);
	}
	else
	{
		flags = strm.uint16();
	}

	item.setGameRecordLength(gameRecordLength);

	item.m_gameFlags			= flags >> 3;
	item.m_positionId			= flags & flags::Non_Standard_Start ? 0 : variant::Standard;
	item.m_setup				= bool(flags & flags::Non_Standard_Start);

	// White and Black player names
	uint32_t whiteBlackHigh	= strm.get();
	uint32_t whiteId			= strm.uint16() | (whiteBlackHigh >> 4) << 16;
	uint32_t blackId			= strm.uint16() | (whiteBlackHigh & 0x0f) << 16;

	NamebasePlayer* whitePlayer =
		::check(static_cast<NamebasePlayer*>(m_playerList->lookup(whiteId)->entry));
	NamebasePlayer* blackPlayer =
		::check(static_cast<NamebasePlayer*>(m_playerList->lookup(blackId)->entry));

	whitePlayer->incrRef(); blackPlayer->incrRef();

	item.m_player[color::White] = whitePlayer;
	item.m_player[color::Black] = blackPlayer;

	// Event, Site and Round names
	uint32_t eventSiteRnd_High	= strm.get();
	uint32_t eventId				= strm.uint16() | ((eventSiteRnd_High >> 5) << 16);
	uint32_t siteId				= strm.uint16() | (((eventSiteRnd_High >> 2) & 7) << 16);
	uint32_t roundId				= strm.uint16() | ((eventSiteRnd_High & 3) << 16);

	NamebaseEvent* event	= ::check(static_cast<NamebaseEvent*>(m_eventList->lookup(eventId)->entry));
	NamebaseSite*  site	= ::check(static_cast<NamebaseSite* >(m_siteList->lookup(siteId)->entry));
	NamebaseEntry* round	= ::check(static_cast<NamebaseEntry*>(m_roundList->lookup(roundId)->entry));

	m_roundLookup[index] = round;

	unsigned rnd, subrnd;

	if (Reader::parseRound(round->name(), rnd, subrnd))
	{
		item.m_round = rnd;
		item.m_subround = subrnd;
	}

	uint16_t varCount	= strm.uint16();
	uint16_t ecoCode	= strm.uint16();

	item.m_result	= varCount >> 12;
	item.m_eco		= ecoCode ? (ecoCode - 1)/131 + 1 : 0;

	item.m_variationCount	= varCount & 15;
	item.m_commentCount		= (varCount >> 4) & 15;
	item.m_annotationCount	= (varCount >> 8) & 15;

	// Date and EventDate are stored in four bytes
	uint32_t d = strm.uint32();
	Date date;

	date.setYMD((d >> 9) & 2047, (d >> 5) & 15, d & 31);
	item.m_dateYear = Date::encodeYearTo10Bits(date.year());
	item.m_dateMonth = date.month();
	item.m_dateDay = date.day();

	if (date.year() && (d >> 29))
		date.setYMD((d >> 29) + date.year() - 4, (d >> 25) & 15, (d >> 20) & 31);
	else
		date.clear();

	if (event->site() == this->namebase(Namebase::Site).emptySite())
	{
		event::Mode mode = Reader::getEventMode(event->name(), site->name());

		switch (int(mode))
		{
			case event::PaperMail:
			case event::Email:
				event->setTimeMode_(time::Corr);
				break;
		}

		event->setSite_(site);
		event->setDate_(date);
		event->setEventMode_(mode);
	}
	else if (event->site() != site || event->date() != date)
	{
		event::Mode	eventMode	= Reader::getEventMode(event->name(), site->name());
		time::Mode	timeMode		= time::Unknown;

		switch (int(eventMode))
		{
			case event::PaperMail:
			case event::Email:
				timeMode = time::Corr;
				break;
		}

		Namebase& namebase = this->namebase(Namebase::Event);

		event = namebase.insertEvent(	event->name(),
												m_eventList->nextId(),
												date.year(),
												date.month(),
												date.day(),
												event->type(),
												timeMode,
												eventMode,
												maxEventCount(),
												site);

		if (event == 0)
		{
			gameInfoList().resize(index);
			IO_RAISE(Index, Load_Failed, "too many events; load aborted");
		}

		m_eventList->addEntry(eventId, event);
		namebase.setNextId(mstl::max(event->id() + 1, namebase.nextId()));
	}

	if (event->frequency() == 0)
		site->incrRef();

	round->incrRef();
	event->incrRef();

	item.m_event = event;

	uint16_t whiteRating = strm.uint16();
	uint16_t blackRating = strm.uint16();

	rating::Type whiteRatingType = rating::Type((whiteRating >> 12) & 7);
	rating::Type blackRatingType = rating::Type((blackRating >> 12) & 7);

	item.m_pd[color::White].ratingType = whiteRatingType;
	item.m_pd[color::Black].ratingType = blackRatingType;

	if (whiteRatingType == rating::Elo)
	{
		item.m_player[color::White]->setElo(
			item.m_pd[color::White].elo = rating::clip(whiteRating & 0x0fffu));
	}
	else
	{
		item.m_player[color::White]->setRating(
			whiteRatingType,
			item.m_pd[color::White].rating = rating::clip(whiteRating & 0x0fffu));
	}

	if (blackRatingType == rating::Elo)
	{
		item.m_player[color::Black]->setElo(
			item.m_pd[color::Black].elo = rating::clip(blackRating & 0x0fffu));
	}
	else
	{
		item.m_player[color::Black]->setRating(
			blackRatingType,
			item.m_pd[color::Black].rating = rating::clip(blackRating & 0x0fffu));
	}

	if (item.m_positionId == variant::Standard)
	{
		uint8_t index = strm.get();

		// IMPORTANT NOTE: stored line index is probably broken (Scid bug)
		if (index < StoredLine::count())
			item.m_ecoKey = StoredLine::getLine(index).ecoKey();
	}
	else
	{
		strm.skip(1);
	}

	// IMPORTANT NOTE: the material signature is possibly faulty
	// (its an overflow bug in Scid; reported as #2992119)
	// This has an significant impact to position search (tree search); some games will
	// probably not be found.
	unsigned materialSignature = strm.uint24();

	item.m_plyCount = strm.get();
	Byte count = strm.get();

	// the first byte of HomePawnData has high bits of the NumHalfMoves counter in its top two bits
	item.m_plyCount |= unsigned((count >> 6)) << 8;
	count &= 63;

	hp::Pawns hp;
	strm.get(hp.bytes, sizeof(hp.bytes));
	::swapHomePawnBytes(hp.bytes);

	// IMPORTANT NOTE: we have to clear garbage data (forgotten memset in Scid)
	::memset(hp.bytes + mstl::div2(count + 1), 0, mstl::div2(16 - count));
	if (mstl::is_odd(count))
		hp.bytes[mstl::div2(count)] &= 0x0f;

	// IMPORTANT NOTE:
	// In some cases the home pawn count is zero although all pawns have moved (Scid bug).
	// This has an significant impact to position search (tree search); some games will
	// probably not be found.
	item.m_signature.setHomePawns(count, hp);
	item.setMaterial(material::si3::Signature(materialSignature));
	item.m_signature.m_promotions	= !!(flags & flags::Promotion);
	item.m_signature.m_underPromotions = !!(flags & flags::Under_Promotion);
	item.m_signature.m_castling = 0; // leave this empty
}


void
Codec::reloadDescription(mstl::string const& rootname)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	char header[MaxIndexHeaderSize];

	mstl::string	filename(rootname + m_extIndex);
	mstl::string	descr;
	mstl::string	str;
	mstl::fstream	stream;

	checkPermissions(filename);
	openFile(stream, filename, MagicIndexFile);

	if (!stream.read(header, m_headerSize))
		IO_RAISE(Index, Corrupted, "unexpected end of file");

	ByteStream bstrm(header, m_headerSize);

	bstrm.skip(12);
	bstrm[119] = '\0';	// to be sure
	mstl::string description;
	getRecodedDescription(reinterpret_cast<char const*>(bstrm.data()), description, *m_codec);
	setDescription(description);
}


void
Codec::reloadNamebases(	mstl::string const& rootname,
								mstl::string const& originalSuffix,
								Progress& progress)
{
	M_ASSERT(originalSuffix == "si3" || originalSuffix == "si4" || originalSuffix == "si5");

	mstl::string	filename(rootname + m_extNamebase);
	mstl::fstream	stream;

	checkPermissions(filename);
	openFile(stream, filename, MagicNamebase);

	unsigned count[Namebase::Round + 1];
	unsigned maxFreq[Namebase::Round + 1];
	unsigned total = 0;

	stream.set_bufsize(65536);
	ByteIStream bstrm(stream);

	bstrm.skip(4);	// skip timestamp

	total += (count[Namebase::Player] = bstrm.uint24());
	total += (count[Namebase::Event ] = bstrm.uint24());
	total += (count[Namebase::Site  ] = bstrm.uint24());
	total += (count[Namebase::Round ] = bstrm.uint24());

	maxFreq[Namebase::Player]	= bstrm.uint24();
	maxFreq[Namebase::Event]	= bstrm.uint24();
	maxFreq[Namebase::Site]		= bstrm.uint24();
	maxFreq[Namebase::Round]   = bstrm.uint24();

	ProgressWatcher watcher(progress, total);
	progress.message("read-namebase");

	m_progressFrequency		= progress.frequency(total, 1000);
	m_progressReportAfter	= m_progressFrequency;
	m_progressCount			= 0;

	reloadNamebase(bstrm,
						namebase(Namebase::Player),
						*m_playerList,
						maxFreq[Namebase::Player],
						count[Namebase::Player],
						progress);
	m_progressCount += count[Namebase::Player];
	m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
	reloadNamebase(bstrm,
						namebase(Namebase::Event),
						*m_eventList,
						maxFreq[Namebase::Event],
						count[Namebase::Event],
						progress);
	m_progressCount += count[Namebase::Event];
	m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
	reloadNamebase(bstrm,
						namebase(Namebase::Site),
						*m_siteList,
						maxFreq[Namebase::Site],
						count[Namebase::Site],
						progress);
	m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
	reloadNamebase(bstrm,
						namebase(Namebase::Round),
						*m_roundList,
						maxFreq[Namebase::Round],
						count[Namebase::Round],
						progress);
}


void
Codec::reloadNamebase(	ByteIStream& bstrm,
								Namebase& base,
								NameList& shadowBase,
								unsigned maxFreq,
								unsigned count,
								Progress& progress)
{
	M_ASSERT(m_codec);

	if (count == 0)
		return;

	mstl::string name;
	mstl::string str;

	char buf[1024];

	str.hook(buf, 1024);

	for (unsigned i = 0; i < count; ++i)
	{
		if (m_progressReportAfter == i)
		{
			progress.update(i + m_progressCount);
			m_progressReportAfter += m_progressFrequency;
		}

		unsigned index = (count >= 65536) ? bstrm.uint24() : bstrm.uint16();

		__attribute__((unused))
		unsigned freq = (maxFreq >= 65536)
								? bstrm.uint24()
								: (maxFreq >= 256 ? bstrm.uint16() : bstrm.get());

		if (index >= count)
			IO_RAISE(Namebase, Corrupted, "namebase file is broken");

		unsigned length = bstrm.get();

		if (i == 0)
		{
			bstrm.get(buf, length);
		}
		else
		{
			unsigned prefix = bstrm.get();

			if (prefix > length)
				IO_RAISE(Namebase, Corrupted, "namebase file is broken");

			bstrm.get(buf + prefix, length - prefix);
		}

		str.set_size(length);

		if (str.is_7bit())
		{
			base.rename(shadowBase.lookup(index)->entry, str);
		}
		else
		{
			m_codec->toUtf8(str, name);

			if (!sys::utf8::validate(name))
			{
				// the database is opened with wrong encoding
				m_codec->forceValidUtf8(name);
			}

			base.rename(shadowBase.lookup(index)->entry, name);
		}
	}

	base.finishRenaming();
}


void
Codec::readNamebases(mstl::fstream& stream, util::Progress& progress)
{
	M_ASSERT(m_codec);

	unsigned count[Namebase::Round + 1];
	unsigned maxFreq[Namebase::Round + 1];
	unsigned total = 0;

	static_assert(Namebase::Player < U_NUMBER_OF(count), "index out of range");
	static_assert(Namebase::Event  < U_NUMBER_OF(count), "index out of range");
	static_assert(Namebase::Site   < U_NUMBER_OF(count), "index out of range");
	static_assert(Namebase::Round  < U_NUMBER_OF(count), "index out of range");

	stream.set_bufsize(65536);
	ByteIStream bstrm(stream);

	bstrm.skip(4);	// skip timestamp

	total += (count[Namebase::Player] = bstrm.uint24());
	total += (count[Namebase::Event ] = bstrm.uint24());
	total += (count[Namebase::Site  ] = bstrm.uint24());
	total += (count[Namebase::Round ] = bstrm.uint24());

	maxFreq[Namebase::Player]	= bstrm.uint24();
	maxFreq[Namebase::Event]	= bstrm.uint24();
	maxFreq[Namebase::Site]		= bstrm.uint24();
	maxFreq[Namebase::Round]	= bstrm.uint24();

	ProgressWatcher watcher(progress, total);

	m_progressFrequency		= progress.frequency(total, 1000);
	m_progressReportAfter	= m_progressFrequency;
	m_progressCount			= 0;

	if (!m_codec->hasEncoding())
	{
		if (!m_hasMagic)
		{
			progress.message("preload-namebase");
			preloadNamebase(bstrm, maxFreq[Namebase::Player], count[Namebase::Player], progress);
			m_progressCount += count[Namebase::Player];
			m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
			preloadNamebase(bstrm, maxFreq[Namebase::Event], count[Namebase::Event], progress);
			m_progressCount += count[Namebase::Event];
			m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
			preloadNamebase(bstrm, maxFreq[Namebase::Site], count[Namebase::Site], progress);
			m_progressReportAfter = m_progressFrequency;
			m_progressCount = 0;
			progress.update(0);
			stream.seekg(36, mstl::ios_base::beg);
			bstrm.reset();
			DataEnd();
		}

		m_codec->reset(m_encoding);
		useEncoding(m_encoding);
	}

	progress.message("read-namebase");

	readNamebase(	bstrm,
						namebase(Namebase::Player),
						*m_playerList,
						maxFreq[Namebase::Player],
						count[Namebase::Player],
						maxPlayerCount(),
						progress);
	m_progressCount += count[Namebase::Player];
	m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
	readNamebase(	bstrm,
						namebase(Namebase::Event),
						*m_eventList,
						maxFreq[Namebase::Event],
						count[Namebase::Event],
						maxEventCount(),
						progress);
	m_progressCount += count[Namebase::Event];
	m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
	readNamebase(	bstrm,
						namebase(Namebase::Site),
						*m_siteList,
						maxFreq[Namebase::Site],
						count[Namebase::Site],
						maxSiteCount(),
						progress);
	m_progressCount += count[Namebase::Site];
	m_progressReportAfter = m_progressFrequency - (m_progressCount % m_progressFrequency);
	readNamebase(	bstrm,
						namebase(Namebase::Round),
						*m_roundList,
						maxFreq[Namebase::Round],
						count[Namebase::Round],
						::MaxRoundCount,
						progress);
	namebases().setModified(false);
}


void
Codec::preloadNamebase(ByteIStream& bstrm, unsigned maxFreq, unsigned count, util::Progress& progress)
{
	if (count == 0)
		return;

	unsigned skipFreq = maxFreq >= 65536 ? 3 : (maxFreq >= 256 ? 2 : 1);

	mstl::function<uint32_t (void)> getCount(
			count >= 65536 ? &ByteStream::getUint24 : &ByteStream::getUint16,
			&bstrm);

	char buf[256];

	for (unsigned i = 0; i < count; ++i)
	{
		if (m_progressReportAfter == i)
		{
			progress.update(i + m_progressCount);
			m_progressReportAfter += m_progressFrequency;
		}

		unsigned index = getCount();

		if (index >= count)
			IO_RAISE(Namebase, Corrupted, "namebase file is broken");

		bstrm.skip(skipFreq);

		unsigned length = bstrm.get();

		if (i == 0)
		{
			bstrm.get(buf, length);
		}
		else
		{
			unsigned prefix = bstrm.get();

			if (prefix > length)
				IO_RAISE(Namebase, Corrupted, "namebase file is broken");

			bstrm.get(buf + prefix, length - prefix);
		}

		HandleData(buf, length);
	}

	progress.update(m_progressCount + count);
}


void
Codec::readNamebase(	ByteIStream& bstrm,
							Namebase& base,
							NameList& shadowBase,
							unsigned maxFreq,
							unsigned count,
							unsigned limit,
							util::Progress& progress)
{
	typedef Namebase::Type Type;

	M_ASSERT(count >= base.size());
	M_ASSERT(count <= limit);
	M_ASSERT(m_codec);
	M_ASSERT(m_codec->hasEncoding());

	if (count == 0)
		return;

	mstl::function<uint32_t (void)> getCount(
			count >= 65536 ? &ByteStream::getUint24 : &ByteStream::getUint16,
			&bstrm);
	mstl::function<uint32_t (void)> getFreq(
			maxFreq >= 65536
				? &ByteStream::getUint24
				: (maxFreq >= 256 ? &ByteStream::getUint16 : &ByteStream::getUint8),
			&bstrm);

	mstl::string name;
	mstl::string str;
	mstl::string tmp;

	char buf[512];
	Type type(base.type());

	base.reserve(count, limit);
	shadowBase.reserve(count);
	str.hook(buf, sizeof(buf));

	for (unsigned i = 0; i < count; ++i)
	{
		if (m_progressReportAfter == i)
		{
			progress.update(i + m_progressCount);
			m_progressReportAfter += m_progressFrequency;
		}

		unsigned index = getCount();

		if (index >= count)
			IO_RAISE(Namebase, Corrupted, "namebase file is broken");

		__attribute__((unused))
		unsigned freq = getFreq();

		unsigned length = bstrm.get();
		unsigned prefix;

		if (i == 0)
		{
			bstrm.get(buf, length);
		}
		else
		{
			prefix = bstrm.get();

			if (prefix > length)
				IO_RAISE(Namebase, Corrupted, "namebase file is broken");

			bstrm.get(buf + prefix, length - prefix);
		}

		unsigned stripped	= ::strippedLength(str, length);
		char remember = str.c_str()[stripped];

		// Bug in Scid: it is possible to enter trailing spaces.
		str.set_size(stripped);
		m_codec->toUtf8(str, name);

		if (!sys::utf8::validate(name))
		{
			// the database is opened with wrong encoding
			m_codec->forceValidUtf8(name);
		}

		if (name.empty() || name.readonly())
		{
			char* p = base.alloc(name.size());
			::memcpy(p, name.c_str(), name.size() + 1);
			name.hook(p, name.size());
		}

		switch (int(type))
		{
			case Namebase::Player:
				{
					mstl::string	value;
					country::Code	country	= country::Unknown;
					title::ID		title		= title::None;
					species::ID		type		= species::Unspecified;
					sex::ID			sex		= sex::Unspecified;

					tmp.assign(name.c_str(), name.size());

					while (Reader::Tag tag = Reader::extractPlayerData(tmp, value))
					{
						switch (tag)
						{
							case Reader::Elo:			break; // cannot be used
							case Reader::Country:	country = country::fromString(value); break;
							case Reader::Human:		type = species::Human; break;
							case Reader::Program:	type = species::Program; break;
							case Reader::None:		break;

							case Reader::Title:
								title = title::fromString(value);
								type = species::Human;
								break;

							case Reader::Sex:
								sex = sex::fromChar(*value);
								type = species::Human;
								break;
						}
					}

					// NOTE: we don't trust the frequency value, it is
					// probably faulty due to a bug in Scid.
					shadowBase.append(
						str,
						index,
						base.insertPlayer(name, index, country, title, type, sex, 0, limit),
						*m_codec);
				}
				break;

			case Namebase::Site:
				{
					tmp.assign(name.c_str(), name.size());
					country::Code country = Reader::extractCountryFromSite(tmp);
					shadowBase.append(str, index, base.insertSite(name, index, country, limit), *m_codec);
				}
				break;

			case Namebase::Event:
				shadowBase.append(
					str,
					index,
					base.insertEvent(name, index, limit, namebase(Namebase::Site).emptySite()),
					*m_codec);
				break;

			case Namebase::Round:
				shadowBase.append(str, index, base.insert(name, index, limit), *m_codec);
				break;
		}

		str.data()[stripped] = remember; // because needed for next entry
	}

	progress.update(m_progressCount + count);
	shadowBase.finish();
	base.setNextId(count);
}


void
Codec::doEncoding(util::ByteStream& strm,
						GameData const& data,
						Signature const& signature,
						unsigned langFlags,
						TagBits const& allowedTags,
						bool allowExtraTags)
{
	M_ASSERT(gameInfoList().size() <= maxGameCount());
	M_ASSERT(namebase(Namebase::Player).size() <= maxPlayerCount());
	M_ASSERT(namebase(Namebase::Event).size() <= maxEventCount());
	M_ASSERT(namebase(Namebase::Site).size() <= maxSiteCount());
	M_ASSERT(namebase(Namebase::Round).size() <= ::MaxRoundCount);

	Encoder encoder(strm, *m_codec);
	encoder.doEncoding(signature, langFlags, data, allowedTags, allowExtraTags);
}


db::Consumer*
Codec::getConsumer(format::Type srcFormat)
{
	return new Consumer(srcFormat, *this, encoding(), Consumer::TagBits(true), true);
}


void
Codec::writeNamebases(mstl::string const& filename)
{
	if (m_isVersion5) { writeNamebasesSi5(filename); return; }

	mstl::string namebaseTempFilename(filename + ".temp.38583276");

	try
	{
		mstl::fstream namebaseStream;
		openFile(namebaseStream, namebaseTempFilename, MagicNamebase, Truncate);
		writeNamebases(namebaseStream);
		sys::file::rename(namebaseTempFilename, filename, true);
	}
	catch (...)
	{
		sys::file::deleteIt(namebaseTempFilename);
		throw;
	}
}


void
Codec::writeNamebases(mstl::ostream& stream, util::Progress& progress)
{
	writeNamebases(stream, &progress);
}


void
Codec::writeNamebases(mstl::ostream& stream, util::Progress* progress)
{
	M_ASSERT(m_codec && m_codec->hasEncoding());

	unsigned char buf[28];
	ByteStream bstrm(buf, sizeof(buf));

	m_playerList->update(namebase(Namebase::Player), *m_codec);
	m_eventList ->update(namebase(Namebase::Event ), *m_codec);
	m_siteList  ->update(namebase(Namebase::Site  ), *m_codec);
	m_roundList ->update(namebase(Namebase::Round ), *m_codec);

	unsigned total =
		m_playerList->size() + m_eventList->size() + m_siteList->size() + m_roundList->size();

	ProgressWatcher watcher(progress, total);

	if (progress)
	{
		progress->message("write-namebase");

		m_progressFrequency		= progress->frequency(total, 1000);
		m_progressReportAfter	= m_progressFrequency;
		m_progressCount			= 0;
	}
	else
	{
		m_progressReportAfter = unsigned(-1);
	}

	// we have to recomnpute frequency values of site base
	// Scidb: one ref for each event with this site
	// Scid:  one ref for each game with this site
	for (unsigned i = 0; i < m_siteList->size(); ++i)
		(*m_siteList)[i]->frequency = 0;

	m_siteList->resetMaxFrequency();

	for (unsigned i = 0; i < m_eventList->size(); ++i)
	{
		NameList::Node const* event = (*m_eventList)[i];

		if (event->entry)
		{
			unsigned siteId = static_cast<NamebaseEvent*>(event->entry)->site()->id();
			m_siteList->updateMaxFrequency(m_siteList->lookup(siteId)->frequency += event->frequency);
		}
	}

	// ensure that the frequencies do not overflow (but this should be impossible)
	::checkNamebase(m_playerList->maxFrequency(), "maximal frequency exceeded in player base");
	::checkNamebase(m_eventList ->maxFrequency(), "maximal frequency exceeded in event base");
	::checkNamebase(m_siteList  ->maxFrequency(), "maximal frequency exceeded in site base");
	::checkNamebase(m_roundList ->maxFrequency(), "maximal frequency exceeded in round base");

	bstrm << uint32_t(sys::time::time());
	bstrm << uint24_t(m_playerList->size());
	bstrm << uint24_t(m_eventList ->size());
	bstrm << uint24_t(m_siteList  ->size());
	bstrm << uint24_t(m_roundList ->size());
	bstrm << uint24_t(m_playerList->maxFrequency());
	bstrm << uint24_t(m_eventList ->maxFrequency());
	bstrm << uint24_t(m_siteList  ->maxFrequency());
	bstrm << uint24_t(m_roundList ->maxFrequency());

	stream.write(buf, sizeof(buf));

	writeNamebase(stream, *m_playerList, progress);
	writeNamebase(stream, *m_eventList, progress );
	writeNamebase(stream, *m_siteList, progress);
	writeNamebase(stream, *m_roundList, progress);

	namebases().setModified(false);
}


void
Codec::writeNamebase(mstl::ostream& stream, NameList& base, util::Progress* progress)
{
	if (base.isEmpty())
		return;

	M_ASSERT(base.maxFrequency() <= ::MaxFrequency);

	unsigned char	buf[32768];
	ByteOStream		bstrm(stream, buf, sizeof(buf));
	unsigned			i = 0;

	NameList::Node const* node = base.first();
	NameList::Node const* prev = node;

	M_ASSERT(node->encoded.size() < 256);
	M_ASSERT(node->id < base.size());

	::writeId(bstrm, node->id, base.size());
	::writeFrequency(bstrm, node->frequency, base.maxFrequency());

	bstrm.put(node->encoded.size());
	bstrm.put(node->encoded.c_str(), node->encoded.size());

	for (node = base.next(); node; node = base.next(), ++i)
	{
		if (m_progressReportAfter <= i)
		{
			M_ASSERT(progress);
			progress->update(i + m_progressCount);
			m_progressReportAfter += m_progressFrequency;
		}

		unsigned length = node->encoded.size();
		unsigned prefix = ::prefix(node->encoded, prev->encoded);

		M_ASSERT(length < 256);
		M_ASSERT(prefix <= length);
		M_ASSERT(node->id < base.size());

		::writeId(bstrm, node->id, base.size());
		::writeFrequency(bstrm, node->frequency, base.maxFrequency());

		bstrm.put(length);
		bstrm.put(prefix);
		bstrm.put(node->encoded.c_str() + prefix, length - prefix);

		prev = node;
	}

	bstrm.flush();
}


mstl::string const&
Codec::getRoundEntry(unsigned index) const
{
	NamebaseEntry* entry = m_roundLookup[index];

	if (entry)
		return entry->name();

	return mstl::string::empty_string;
}


void
Codec::releaseRoundEntry(unsigned index)
{
	if (NamebaseEntry* entry = m_roundLookup[index])
		namebase(Namebase::Round).decrRef(entry);
}


bool
Codec::saveRoundEntry(unsigned index, mstl::string const& value)
{
	m_roundEntry = nullptr;

	NamebaseEntry* entry = namebase(Namebase::Round).insert(value, ::MaxRoundCount);

	if (entry == nullptr)
		return false;

	if (index >= m_roundLookup.size())
		m_roundLookup.resize((index + mstl::max(20u, (9*index)/10)));

	namebase(Namebase::Round).incrRef(entry);
	m_roundEntry = m_roundLookup[index];
	m_roundLookup[index] = entry;

	return true;
}


void
Codec::restoreRoundEntry(unsigned index)
{
	NamebaseEntry* entry = m_roundLookup[index];

	if (entry)
		namebase(Namebase::Round).decrRef(entry);

	if (m_roundEntry)
	{
		namebase(Namebase::Round).incrRef(m_roundEntry);

		if (entry && m_roundLookup[index]->frequency() == 0)
			m_roundLookup[index] = m_roundEntry;

		m_roundEntry = nullptr;
	}
}


void
Codec::useOverflowEntry(unsigned index)
{
	Namebase& roundBase = namebase(Namebase::Round);

	NamebaseEntry* entry = roundBase.insert("overflow", ::MaxRoundCount);

	if (entry == nullptr)
	{
		unsigned freq = unsigned(-1);

		for (int i = ::MaxRoundCount - 1 ; i >= 0; --i)
		{
			NamebaseEntry* e = roundBase.entryAt(i);

			M_ASSERT(e);

			if (e->frequency() < freq)
			{
				entry = e;

				if (e->frequency() == 1)
					break;

				freq = e->frequency();
			}
		}

		roundBase.rename(entry, "overflow");
	}

	if (index >= m_roundLookup.size())
		m_roundLookup.resize((index + mstl::max(20u, (9*index)/10)));

	m_roundLookup[index] = entry;
	roundBase.incrRef(entry);
}


bool
Codec::usingAsyncReader() const
{
	return m_gameData->isInAsyncMode();
}


BlockFileReader*
Codec::getAsyncReader()
{
	return m_gameData->openAsyncReader();
}


void
Codec::closeAsyncReader(BlockFileReader* reader)
{
	M_ASSERT(reader);
	m_gameData->closeAsyncReader(reader);
}


Move
Codec::findExactPosition(	GameInfo const& info,
									Board const& position,
									bool skipVariations,
									BlockFileReader* reader)
{
	ByteStream src;
	getGameRecord(info, reader ? *reader : m_gameData->reader(), src);
	Decoder decoder(src, *m_codec);
	return decoder.findExactPosition(position, skipVariations);
}


bool
Codec::getAttributes(mstl::string const& filename,
							int& numGames,
							db::type::ID& type,
							mstl::string* description)
{
	M_REQUIRE(util::misc::file::suffix(filename) == "si3" || util::misc::file::suffix(filename) == "si4" || util::misc::file::suffix(filename) == "si5");

	mstl::fstream strm(sys::file::internalName(filename), mstl::ios_base::in | mstl::ios_base::binary);

	if (!strm)
		return false;

	char header[120];

	strm.seekp(8, mstl::ios_base::beg);

	if (!strm.read(header, description ? sizeof(header) : 10))
		return false;

	ByteStream bstrm(header, sizeof(header));

	bstrm.skip(2); // skip version
	type = Decoder::decodeType(bstrm.uint32());
	numGames	= bstrm.uint24();

	if (description)
	{
		sys::utf8::Codec codec(sys::utf8::Codec::utf8());

		bstrm.skip(3);			// skip autoload
		header[119] = '\0';	// to be sure
		getRecodedDescription(reinterpret_cast<char const*>(bstrm.data()), *description, codec);
	}

	strm.close();
	return true;
}


void
Codec::getSuffixes(mstl::string const& filename, StringList& result)
{
	mstl::string ext;

	if (filename.find('.') == mstl::string::npos)
		ext = filename;
	else
		ext = ::util::misc::file::suffix(filename);

	result.push_back(ext);
	ext[1] = 'g';
	result.push_back(ext);
	ext[1] = 'n';
	result.push_back(ext);

	if (ext[2] == '4')
		result.push_back("ssc");
}


void
Codec::removeAllFiles(mstl::string const& rootname)
{
	M_ASSERT(!m_gameStream.is_open());

	mstl::string base(rootname);

	::sys::file::deleteIt(base + m_extNamebase);
	::sys::file::deleteIt(base + m_extGame);
	::sys::file::deleteIt(base + m_extIndex);
	::sys::file::deleteIt(base + ".ssc");
}

// vi:set ts=3 sw=3:
