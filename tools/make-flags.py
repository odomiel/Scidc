#!/usr/bin/env python3
# ======================================================================
# Erzeugt die Flaggen von Scidc aus den gemeinfreien Vorlagen bei
# Wikimedia Commons.
#
# Warum: die vorherigen Flaggen stammten laut tcl/flags/readme von
# addgadget.com -- eine Seite, die es nicht mehr gibt, ohne Lizenzangabe.
# Die Zuordnung Laendercode -> Commons-Datei steht in
# tools/flag-mapping.tsv; nur Eintraege mit Status "frei" oder "auflage"
# werden ersetzt.
#
# Ablauf (Netzzugang noetig):
#   1. tools/flag-fetch.sh laedt die von Commons gerenderten PNGs
#   2. Tk normalisiert sie auf 8 Bit (Wikimedia liefert 2-Bit-Paletten)
#   3. dieses Skript setzt die drei Darstellungen zusammen:
#        - runde Plakette 72x72  -> tcl/flags/<CODE>.png
#        - quadratisch 16/22/32  -> eingebettet in tcl/utils/countries.tcl
#
# Warum die *gerenderten* PNGs und nicht die SVG direkt: Tks SVG-Leser
# (nanosvg) kennt <use> nicht -- bei Chinas Flagge fehlten dadurch vier
# der fuenf Sterne. Wikimedias eigener Rasterer macht es richtig.
#
# Die 16x11-Flaggen der Oberfläche bleiben unangetastet: sie sind
# nachweislich der famfamfam-Satz und gemeinfrei (siehe COPYRIGHT).
# ======================================================================

import sys, os, math
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import png

def load(path):
    return png.read(path)

def sample_box(fw, fh, fp, x0, x1, y0, y1, over_white=True):
    """Mittelt ueber den Quellbereich -- verhindert Treppen beim Verkleinern.

    Durchsichtige Stellen werden auf Weiss gelegt: Nepals Wimpelform und
    aehnliche Flaggen haben transparente Ecken, die sonst schwarz wuerden.
    """
    x0=max(0,int(x0)); x1=min(fw,max(x0+1,int(math.ceil(x1))))
    y0=max(0,int(y0)); y1=min(fh,max(y0+1,int(math.ceil(y1))))
    r=g=b=a=n=0
    for y in range(y0,y1):
        base=y*fw
        for x in range(x0,x1):
            k=(base+x)*4
            r+=fp[k]; g+=fp[k+1]; b+=fp[k+2]; a+=fp[k+3]; n+=1
    if not n: return (255,255,255,255) if over_white else (0,0,0,0)
    r//=n; g//=n; b//=n; a//=n
    if over_white and a < 255:
        f=a/255.0
        r=int(r*f+255*(1-f)); g=int(g*f+255*(1-f)); b=int(b*f+255*(1-f)); a=255
    return (r,g,b,a)

def badge(src, out, size=72):
    fw,fh,fp = load(src)
    R=(size-4)/2.0; cx=cy=(size-1)/2.0
    # Flaggen mit durchsichtigen Ecken sind nicht rechteckig (Nepal). Die
    # wuerden beim Fuellen beschnitten, also werden sie eingepasst.
    trans=sum(1 for k in range(3, len(fp), 4) if fp[k] < 128)
    ragged = trans > 0.04*fw*fh
    if ragged:
        s=min((2*R)/fw,(2*R)/fh)*0.95   # ganze Flagge sichtbar
    else:
        s=max((2*R)/fw,(2*R)/fh)        # Flagge fuellt den Kreis
    step=1.0/s
    px=bytearray(size*size*4)
    for y in range(size):
        for x in range(size):
            dx,dy=x-cx,y-cy; d=math.hypot(dx,dy)
            if d>R+0.7: continue
            sx=(x-cx)/s+fw/2.0; sy=(y-cy)/s+fh/2.0
            r,g,b,a = sample_box(fw,fh,fp, sx-step/2, sx+step/2, sy-step/2, sy+step/2)
            t=(y-(cy-R))/(2*R)
            if t<0.50:
                hl=(0.50-t)/0.50; w=0.70*hl*hl*hl+0.18*hl
                r=r+(255-r)*w; g=g+(255-g)*w; b=b+(255-b)*w
            else:
                sh=(t-0.50)/0.50; w=0.34*sh*sh
                r*=(1-w); g*=(1-w); b*=(1-w)
            e=d/R
            if e>0.88:
                w=min(1.0,(e-0.88)/0.12)*0.72
                r*=(1-w); g*=(1-w); b*=(1-w)
            alpha=255 if d<=R-0.7 else int(255*max(0.0,(R+0.7-d)/1.4))
            k=(y*size+x)*4
            px[k]=int(min(255,max(0,r))); px[k+1]=int(min(255,max(0,g)))
            px[k+2]=int(min(255,max(0,b))); px[k+3]=min(alpha, a if a else 255)
    png.write(out,size,size,px)

def square(src, out, size):
    """Flagge als Rechteck mit 1px-Rand, mittig im quadratischen Feld."""
    fw,fh,fp=load(src)
    inner_w=size-2
    inner_h=max(1,int(round(inner_w*fh/fw)))
    if inner_h>size-2: inner_h=size-2; inner_w=max(1,int(round(inner_h*fw/fh)))
    ox=(size-inner_w-2)//2; oy=(size-inner_h-2)//2
    px=bytearray(size*size*4)
    sxs=fw/inner_w; sys_=fh/inner_h
    for j in range(inner_h+2):
        for i in range(inner_w+2):
            X=ox+i; Y=oy+j
            if not (0<=X<size and 0<=Y<size): continue
            k=(Y*size+X)*4
            if i==0 or j==0 or i==inner_w+1 or j==inner_h+1:
                px[k:k+4]=bytes((0,0,0,140))          # Rand
                continue
            r,g,b,a=sample_box(fw,fh,fp,(i-1)*sxs,(i)*sxs,(j-1)*sys_,(j)*sys_)
            px[k]=r; px[k+1]=g; px[k+2]=b; px[k+3]=a if a else 255
    png.write(out,size,size,px)
