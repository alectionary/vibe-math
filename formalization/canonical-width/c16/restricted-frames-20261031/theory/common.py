from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (ROOT / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (ROOT / 'pools/zcoords.txt').read_text().split()]
def dot(a, b): return (a & b).bit_count() & 1
def blk(v, b): return (v >> (16 * b)) & 0xffff
def supp_blocks(v): return tuple(b for b in range(8) if blk(v, b))
def rot16(w, k): k %= 16; return ((w << k) | (w >> (16 - k))) & 0xffff if k else w
def rank(vs):
    piv = {}
    r = 0
    for v in vs:
        while v:
            h = v.bit_length() - 1
            if h in piv: v ^= piv[h]
            else: piv[h] = v; r += 1; break
    return r
