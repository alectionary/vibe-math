// Complete a partial CSS frame that already contains 15 seed-4 X monomials.
//
// Argument: 16 comma-free type digits in {0,1,2,*} . The star is the omitted
// seed-4 bit. For every other bit the digit selects one of the three Z-pool
// partners whose seed-4 block is that monomial. Those 15 pairs are forced by
// the Gram identity. This program searches the complementary pools for 113
// further pool pairs whose full symplectic Gram matrix is I_113.
//
//   g++ -O3 -std=c++17 quotient_complete.cpp -o quotient_complete
//   ./quotient_complete pools/xcoords.txt pools/zcoords.txt '02...' [node_limit]
#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <functional>
#include <iostream>
#include <string>
#include <vector>

using U = unsigned __int128;

static int pop2(uint64_t x) { return __builtin_popcountll(x); }
static int dot(U a, U b) {
    return (pop2((uint64_t)a & (uint64_t)b) + pop2((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) & 1;
}
static U rot(U v, int h) {
    U o = 0;
    for (int s = 0; s < 8; s++) {
        uint32_t b = (uint32_t)((v >> (16 * s)) & 0xffffu);
        if (h) b = ((b << h) | (b >> (16 - h))) & 0xffffu;
        o |= (U)b << (16 * s);
    }
    return o;
}
static std::vector<U> load(const std::string& path) {
    std::ifstream in(path);
    if (!in) {
        std::perror(path.c_str());
        std::exit(1);
    }
    std::vector<U> out;
    std::string line;
    while (std::getline(in, line)) {
        if (line.empty()) continue;
        U v = 0;
        for (char c : line) {
            if (c == ' ' || c == '\r') continue;
            int d = (c <= '9') ? c - '0' : c - 'a' + 10;
            v = (v << 4) | (unsigned)d;
        }
        out.push_back(v);
    }
    return out;
}
static int lead(U v) {
    if (v >> 64) return 127 - __builtin_clzll((uint64_t)(v >> 64));
    return 63 - __builtin_clzll((uint64_t)v);
}

struct Bits {
    uint64_t w[8]{};
    void clear() {
        for (int i = 0; i < 8; i++) w[i] = 0;
    }
    void set(int i) { w[i >> 6] |= 1ull << (i & 63); }
    void reset(int i) { w[i >> 6] &= ~(1ull << (i & 63)); }
    int test(int i) const { return (w[i >> 6] >> (i & 63)) & 1; }
    void fill(int n) {
        clear();
        for (int i = 0; i < n; i++) set(i);
    }
    Bits operator&(const Bits& o) const {
        Bits r;
        for (int i = 0; i < 8; i++) r.w[i] = w[i] & o.w[i];
        return r;
    }
    void keep(const Bits& o) {
        for (int i = 0; i < 8; i++) w[i] &= o.w[i];
    }
    int count() const {
        int c = 0;
        for (int i = 0; i < 8; i++) c += pop2(w[i]);
        return c;
    }
    template <class F>
    void each(F f) const {
        for (int k = 0; k < 8; k++) {
            uint64_t m = w[k];
            while (m) {
                int b = __builtin_ctzll(m);
                f((k << 6) + b);
                m &= m - 1;
            }
        }
    }
};

static int rank_of(const std::vector<U>& rows) {
    std::vector<U> piv;
    piv.reserve(rows.size());
    for (U v : rows) {
        for (U row : piv)
            if ((v >> lead(row)) & 1) v ^= row;
        if (!v) continue;
        int p = lead(v);
        for (U& row : piv)
            if ((row >> p) & 1) row ^= v;
        piv.push_back(v);
    }
    return (int)piv.size();
}

int main(int argc, char** argv) {
    if (argc < 4) {
        std::cerr << "usage: quotient_complete xcoords zcoords types [node_limit]\n";
        return 1;
    }
    auto Xall = load(argv[1]);
    auto Zall = load(argv[2]);
    std::string types = argv[3];
    uint64_t limit = argc > 4 ? std::strtoull(argv[4], nullptr, 10) : 200000000ull;
    if (types.size() != 16) {
        std::cerr << "types must be 16 chars\n";
        return 1;
    }
    int drop = -1;
    for (int i = 0; i < 16; i++) {
        char c = types[i];
        if (c == '*') {
            if (drop >= 0) {
                std::cerr << "two drops\n";
                return 1;
            }
            drop = i;
        } else if (c < '0' || c > '2') {
            std::cerr << "bad type\n";
            return 1;
        }
    }
    if (drop < 0) {
        std::cerr << "need a dropped bit marked *\n";
        return 1;
    }
    U xs4 = 0;
    for (U a : Xall)
        if (((a >> 64) & 0xffffffffu) == 1) xs4 = a;
    std::vector<U> proto;
    for (U b : Zall)
        if ((((b >> 64) & 0xffffu) == 1) && dot(xs4, b)) proto.push_back(b);
    if (proto.size() != 3) {
        std::cerr << "expected 3 protos\n";
        return 1;
    }
    std::vector<U> partners;
    std::vector<int> kept;
    for (int p = 0; p < 16; p++) {
        if (p == drop) continue;
        kept.push_back(p);
        partners.push_back(rot(proto[types[p] - '0'], p));
    }
    std::vector<U> X, Z;
    std::vector<int> xId, zId;
    for (int i = 0; i < (int)Xall.size(); i++) {
        bool ok = true;
        for (U b : partners)
            if (dot(Xall[i], b)) {
                ok = false;
                break;
            }
        if (ok) {
            X.push_back(Xall[i]);
            xId.push_back(i);
        }
    }
    for (int j = 0; j < (int)Zall.size(); j++) {
        bool ok = true;
        for (int p : kept)
            if ((Zall[j] >> (64 + p)) & 1) {
                ok = false;
                break;
            }
        if (ok) {
            Z.push_back(Zall[j]);
            zId.push_back(j);
        }
    }
    const int nX = (int)X.size(), nZ = (int)Z.size();
    int rx = rank_of(X), rz = rank_of(Z);
    std::cerr << "drop " << drop << " X " << nX << " rank " << rx << " Z " << nZ << " rank " << rz << "\n";
    if (rx < 113 || rz < 113) {
        std::cerr << "pools do not span\n";
        return 2;
    }
    std::vector<Bits> anti(nX), commZ(nX);
    for (int i = 0; i < nX; i++) {
        for (int j = 0; j < nZ; j++) {
            if (dot(X[i], Z[j])) anti[i].set(j);
            else commZ[i].set(j);
        }
    }

    std::vector<int> cx, cz;
    Bits availX, availZ;
    availX.fill(nX);
    availZ.fill(nZ);
    uint64_t nodes = 0, ranks = 0;
    int best = 0;
    bool found = false;
    std::vector<uint64_t> depth_nodes(114);

    auto rank_bits = [&](const Bits& bits) {
        std::vector<U> rows;
        rows.reserve(bits.count());
        bits.each([&](int i) { rows.push_back(X[i]); });
        ++ranks;
        return rank_of(rows);
    };

    // The surviving X vectors lie in a space of dimension `need`. A frame has to
    // span it, so every coordinate that is still nonzero is hit by some chosen
    // vector. Branch on the coordinate with the fewest surviving hits.
    std::function<void()> rec = [&]() {
        if (found || nodes > limit) return;
        nodes++;
        int k = (int)cx.size();
        depth_nodes[k]++;
        if (k > best) {
            best = k;
            std::cerr << "best " << best << " nodes " << nodes << " availX " << availX.count()
                      << " availZ " << availZ.count() << "\n";
        }
        if (k == 113) {
            found = true;
            std::cout << "FOUND\n";
            for (int t = 0; t < 113; t++) std::cout << xId[cx[t]] << " " << zId[cz[t]] << "\n";
            return;
        }
        int need = 113 - k;
        if (availX.count() < need || availZ.count() < need) return;
        if (rank_bits(availX) < need) return;
        int hits[128] = {};
        availX.each([&](int i) {
            U v = X[i];
            uint64_t lo = (uint64_t)v, hi = (uint64_t)(v >> 64);
            while (lo) {
                hits[__builtin_ctzll(lo)]++;
                lo &= lo - 1;
            }
            while (hi) {
                hits[64 + __builtin_ctzll(hi)]++;
                hi &= hi - 1;
            }
        });
        int bstar = -1, bh = 1 << 30;
        for (int b = 0; b < 128; b++)
            if (hits[b] && hits[b] < bh) {
                bh = hits[b];
                bstar = b;
            }
        if (bstar < 0) return;
        std::vector<int> cands;
        availX.each([&](int i) {
            if ((X[i] >> bstar) & 1) cands.push_back(i);
        });
        Bits savedX = availX, savedZ = availZ;
        for (int i : cands) {
            if (found || nodes > limit) return;
            availX = savedX;
            availZ = savedZ;
            Bits zs = anti[i];
            zs.keep(savedZ);
            zs.each([&](int j) {
                if (found || nodes > limit) return;
                availX = savedX;
                availZ = savedZ;
                availX.reset(i);
                availZ.reset(j);
                for (int t = 0; t < nX; t++)
                    if (availX.test(t) && dot(X[t], Z[j])) availX.reset(t);
                for (int t = 0; t < nZ; t++)
                    if (availZ.test(t) && dot(X[i], Z[t])) availZ.reset(t);
                if (availX.count() < need - 1 || availZ.count() < need - 1) return;
                cx.push_back(i);
                cz.push_back(j);
                rec();
                cx.pop_back();
                cz.pop_back();
            });
        }
        availX = savedX;
        availZ = savedZ;
    };
    rec();
    std::cerr << "depth histogram";
    for (int d = 0; d <= best; d++) std::cerr << " " << d << ":" << depth_nodes[d];
    std::cerr << "\n";
    std::cerr << (found ? "solved" : "exhausted_or_capped") << " best " << best << " nodes " << nodes
              << " ranks " << ranks << "\n";
    return found ? 0 : 2;
}
