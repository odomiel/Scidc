"""Minimaler PNG-Codec (RGBA) -- reicht fuer das, was hier gebraucht wird."""
import zlib, struct

def _paeth(a,b,c):
    p=a+b-c; pa=abs(p-a); pb=abs(p-b); pc=abs(p-c)
    return a if (pa<=pb and pa<=pc) else (b if pb<=pc else c)

def read(path):
    d=open(path,'rb').read()
    assert d[:8]==b'\x89PNG\r\n\x1a\n', path
    i=8; idat=b''; w=h=bits=ct=None; pal=None; trns=None
    while i<len(d):
        ln=struct.unpack('>I',d[i:i+4])[0]; typ=d[i+4:i+8]; body=d[i+8:i+8+ln]
        if typ==b'IHDR': w,h,bits,ct,_,_,inter=struct.unpack('>IIBBBBB',body); assert inter==0
        elif typ==b'PLTE': pal=body
        elif typ==b'tRNS': trns=body
        elif typ==b'IDAT': idat+=body
        elif typ==b'IEND': break
        i+=12+ln
    raw=zlib.decompress(idat)
    ch={0:1,2:3,3:1,4:2,6:4}[ct]
    assert bits==8, f'{path}: {bits} bit'
    stride=w*ch; out=bytearray(); prev=bytearray(stride); p=0
    for _ in range(h):
        f=raw[p]; p+=1; line=bytearray(raw[p:p+stride]); p+=stride
        if f==1:
            for x in range(ch,stride): line[x]=(line[x]+line[x-ch])&255
        elif f==2:
            for x in range(stride): line[x]=(line[x]+prev[x])&255
        elif f==3:
            for x in range(stride):
                a=line[x-ch] if x>=ch else 0
                line[x]=(line[x]+((a+prev[x])>>1))&255
        elif f==4:
            for x in range(stride):
                a=line[x-ch] if x>=ch else 0
                c=prev[x-ch] if x>=ch else 0
                line[x]=(line[x]+_paeth(a,prev[x],c))&255
        out+=line; prev=line
    # in RGBA wandeln
    px=bytearray(w*h*4)
    for k in range(w*h):
        s=k*ch
        if ct==6: px[k*4:k*4+4]=out[s:s+4]
        elif ct==2: px[k*4:k*4+3]=out[s:s+3]; px[k*4+3]=255
        elif ct==0: v=out[s]; px[k*4:k*4+4]=bytes((v,v,v,255))
        elif ct==4: v=out[s]; px[k*4:k*4+4]=bytes((v,v,v,out[s+1]))
        elif ct==3:
            idx=out[s]; px[k*4:k*4+3]=pal[idx*3:idx*3+3]
            px[k*4+3]=trns[idx] if trns and idx<len(trns) else 255
    return w,h,px

def write(path,w,h,px):
    raw=bytearray()
    for y in range(h):
        raw.append(0); raw+=px[y*w*4:(y+1)*w*4]
    def chunk(t,b):
        c=struct.pack('>I',len(b))+t+b
        return c+struct.pack('>I',zlib.crc32(t+b)&0xffffffff)
    d=b'\x89PNG\r\n\x1a\n'
    d+=chunk(b'IHDR',struct.pack('>IIBBBBB',w,h,8,6,0,0,0))
    d+=chunk(b'IDAT',zlib.compress(bytes(raw),9))
    d+=chunk(b'IEND',b'')
    open(path,'wb').write(d)
