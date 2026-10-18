// ======================================================================
// util::ByteStream -- die Grundlage der Grenzpruefung in den Codecs.
//
// Die Codecs lesen Offsets und Laengen aus (moeglicherweise
// praeparierten) Dateien. Dass das ungefaehrlich bleibt, haengt an einer
// Zusicherung: get/uint16/uint24/uint32/skip werfen bei Ueberlauf
// UnexpectedEndOfStreamException. Faellt die weg, laufen alle
// Lesepfade ungebremst ins Heap. Darum stehen die Faelle hier zuerst.
//
// Ebenso geprueft: capacity() ist **base-relativ** (die Ausdehnung des
// Datensatzes), nicht das, was noch zu lesen ist. Der frueher benutzte
// Wert blockSize() - gameOffset() unterlief, weil gameOffset absolut
// ist; sectionPtr() in den SCI-Decodern rechnet gegen capacity().
// ======================================================================

#include "t_assert.h"

#include "u_byte_stream.h"

#include "m_string.h"

using namespace util;


TEST(ByteStream, roundtrip)
{
	ByteStream::Byte buf[16];
	ByteStream out(buf, sizeof(buf));

	out << uint16_t(0x1234);
	out << ByteStream::uint24_t(0x123456);
	out << uint32_t(0x12345678);

	ByteStream in(buf, sizeof(buf));
	CHECK_EQ(in.uint16(), 0x1234);
	CHECK_EQ(in.uint24(), 0x123456);
	CHECK_EQ(in.uint32(), 0x12345678);
}


TEST(ByteStream, big_endian)
{
	// Die Codecs schreiben gross-endig; die Bytereihenfolge ist Teil des
	// Dateiformats und darf sich nicht mit der der Maschine aendern.
	ByteStream::Byte buf[4] = { 0x01, 0x02, 0x03, 0x04 };
	ByteStream in(buf, sizeof(buf));
	CHECK_EQ(in.uint32(), 0x01020304);

	ByteStream in2(buf, sizeof(buf));
	CHECK_EQ(in2.uint16(), 0x0102);
	CHECK_EQ(in2.uint16(), 0x0304);
}


TEST(ByteStream, uint24_full_range)
{
	ByteStream::Byte buf[3] = { 0xff, 0xff, 0xff };
	ByteStream in(buf, sizeof(buf));
	CHECK_EQ(in.uint24(), 0xffffff);
}


TEST(ByteStream, get_throws_at_end)
{
	ByteStream::Byte buf[1] = { 0x42 };
	ByteStream in(buf, sizeof(buf));

	CHECK_EQ(in.get(), 0x42);
	CHECK(in.isEmpty());
	CHECK_THROWS(in.get(), ByteStream::UnexpectedEndOfStreamException);
}


TEST(ByteStream, uint16_throws_on_partial_value)
{
	// Drei Bytes, zwei gelesen: fuer das naechste uint16 fehlt eines.
	ByteStream::Byte buf[3] = { 0x01, 0x02, 0x03 };
	ByteStream in(buf, sizeof(buf));

	CHECK_EQ(in.uint16(), 0x0102);
	CHECK_EQ(in.remaining(), 1);
	CHECK_THROWS(in.uint16(), ByteStream::UnexpectedEndOfStreamException);
}


TEST(ByteStream, uint32_throws_on_partial_value)
{
	ByteStream::Byte buf[7] = { 0, 0, 0, 0, 0, 0, 0 };
	ByteStream in(buf, sizeof(buf));

	CHECK_NOTHROW(in.uint32());
	CHECK_EQ(in.remaining(), 3);
	CHECK_THROWS(in.uint32(), ByteStream::UnexpectedEndOfStreamException);
}


TEST(ByteStream, skip_throws_beyond_end)
{
	ByteStream::Byte buf[8];
	ByteStream in(buf, sizeof(buf));

	CHECK_NOTHROW(in.skip(8));
	CHECK_EQ(in.remaining(), 0);
	CHECK_THROWS(in.skip(1), ByteStream::UnexpectedEndOfStreamException);
}


TEST(ByteStream, capacity_is_base_relative)
{
	ByteStream::Byte buf[32];
	ByteStream in(buf, sizeof(buf));

	CHECK_EQ(in.capacity(), 32);
	in.skip(10);
	// Nach dem Lesen bleibt die Ausdehnung des Datensatzes dieselbe --
	// nur remaining() schrumpft. Genau diese Trennung braucht
	// sectionPtr(), um einen Offset gegen den Datensatz zu pruefen.
	CHECK_EQ(in.capacity(), 32);
	CHECK_EQ(in.remaining(), 22);
	CHECK_EQ(in.tellg(), 10);
}


TEST(ByteStream, window_sees_only_its_part)
{
	// So baut der Codec einen Teilstrom auf einen Abschnitt. Ein Offset,
	// der in den Nachbarn zeigt, bleibt ausserhalb von capacity().
	ByteStream::Byte buf[64];
	ByteStream in(buf + 16, buf + 32);

	CHECK_EQ(in.capacity(), 16);
	CHECK_NOTHROW(in.skip(16));
	CHECK_THROWS(in.get(), ByteStream::UnexpectedEndOfStreamException);
}


TEST(ByteStream, string_stops_at_nul)
{
	ByteStream::Byte buf[8] = { 'a', 'b', 'c', 0, 'd', 'e', 0, 0 };
	ByteStream in(buf, sizeof(buf));

	mstl::string s;
	in.get(s);
	CHECK_EQ(s, "abc");
	CHECK_EQ(in.tellg(), 4);

	mstl::string t;
	in.get(t);
	CHECK_EQ(t, "de");
}


TEST(ByteStream, unterminated_string_throws)
{
	// Eine Zeichenkette ohne Null am Ende des Datensatzes -- der haeufigste
	// Fall in einer beschaedigten oder praeparierten Datei.
	ByteStream::Byte buf[3] = { 'a', 'b', 'c' };
	ByteStream in(buf, sizeof(buf));

	mstl::string s;
	CHECK_THROWS(in.get(s), ByteStream::UnexpectedEndOfStreamException);

	ByteStream in2(buf, sizeof(buf));
	CHECK_THROWS(in2.skipString(), ByteStream::UnexpectedEndOfStreamException);
}


TEST(ByteStream, seek_resets_read_position)
{
	ByteStream::Byte buf[4] = { 0x0a, 0x0b, 0x0c, 0x0d };
	ByteStream in(buf, sizeof(buf));

	CHECK_EQ(in.get(), 0x0a);
	in.seekg(2);
	CHECK_EQ(in.tellg(), 2);
	CHECK_EQ(in.get(), 0x0c);
}

// vi:set ts=3 sw=3:
