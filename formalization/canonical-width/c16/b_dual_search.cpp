// Search for 32 pool pairs whose B-blocks are dual bases and whose full
// symplectic Gram matrix is I_32. Any such matching realizes the block-B
// identity with no cancellation. Pairs are anticommuting weight-16 logical
// classes with both B-components nonzero. B is seeds 4 and 5, bits 64..95.
//
// This is a necessary shape for a cancellation-free B-identity matching. A
// solution is not yet a 128-pair frame. Exhausting the search would not by
// itself rule out frames whose B-outer-products cancel.
//
//   g++ -O3 -std=c++17 b_dual_search.cpp -o b_dual_search
//   ./b_dual_search xcoords.txt zcoords.txt [node_limit]

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
static uint32_t blockB(U v) { return (uint32_t)((v >> 64) & 0xffffffffu); }

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
            if (c == ' ') continue;
            int d = (c <= '9') ? c - '0' : c - 'a' + 10;
            v = (v << 4) | (unsigned)d;
        }
        out.push_back(v);
    }
    return out;
}

struct Bits {
    uint64_t w[12]{};
    void set(int i) { w[i >> 6] |= 1ull << (i & 63); }
    void reset(int i) { w[i >> 6] &= ~(1ull << (i & 63)); }
    int test(int i) const { return (w[i >> 6] >> (i & 63)) & 1; }
    void fill(int n) {
        for (int i = 0; i < n; i++) set(i);
    }
    Bits operator&(const Bits& o) const {
        Bits r;
        for (int i = 0; i < 12; i++) r.w[i] = w[i] & o.w[i];
        return r;
    }
    Bits& operator&=(const Bits& o) {
        for (int i = 0; i < 12; i++) w[i] &= o.w[i];
        return *this;
    }
    int count() const {
        int c = 0;
        for (int i = 0; i < 12; i++) c += pop2(w[i]);
        return c;
    }
    template <class F>
    void each(F f) const {
        for (int k = 0; k < 12; k++) {
            uint64_t m = w[k];
            while (m) {
                int b = __builtin_ctzll(m);
                f((k << 6) + b);
                m &= m - 1;
            }
        }
    }
};

static U rot(U v, int h) {
    U o = 0;
    for (int s = 0; s < 8; s++) {
        uint32_t b = (uint32_t)((v >> (16 * s)) & 0xffffu);
        if (h) b = ((b << h) | (b >> (16 - h))) & 0xffffu;
        o |= (U)b << (16 * s);
    }
    return o;
}

int main(int argc, char** argv) {
    if (argc < 3) {
        std::cerr << "usage: b_dual_search xcoords.txt zcoords.txt [node_limit]\n";
        return 1;
    }
    auto X = load(argv[1]);
    auto Z = load(argv[2]);
    const int nX = (int)X.size(), nZ = (int)Z.size();
    uint64_t limit = argc > 3 ? std::strtoull(argv[3], nullptr, 10) : 500000000ull;
    std::vector<uint32_t> XB(nX), ZB(nZ);
    for (int i = 0; i < nX; i++) XB[i] = blockB(X[i]);
    for (int j = 0; j < nZ; j++) ZB[j] = blockB(Z[j]);

    std::vector<Bits> anti(nX), zOrthX(nX), zB0(nX), zB1(nX), xOrthZ(nZ);
    int pairs = 0;
    for (int i = 0; i < nX; i++) {
        if (!XB[i]) continue;
        for (int j = 0; j < nZ; j++) {
            if (!ZB[j]) continue;
            int full = dot(X[i], Z[j]);
            int bd = pop2(XB[i] & ZB[j]) & 1;
            if (full) {
                anti[i].set(j);
                pairs++;
            } else {
                zOrthX[i].set(j);
                xOrthZ[j].set(i);
            }
            if (bd) zB1[i].set(j);
            else zB0[i].set(j);
        }
    }
    std::cerr << "X " << nX << " Z " << nZ << " B-pairs " << pairs << "\n";

    std::vector<int> reps;
    std::vector<char> seen(nX);
    auto index_of = [&](U v) {
        for (int i = 0; i < nX; i++) if (X[i] == v) return i;
        return -1;
    };
    for (int i = 0; i < nX; i++) {
        if (seen[i] || !XB[i]) continue;
        int best = i;
        U bv = X[i];
        for (int h = 0; h < 16; h++) {
            U r = rot(X[i], h);
            int id = index_of(r);
            if (id >= 0) seen[id] = 1;
            if (id >= 0 && r < bv) {
                bv = r;
                best = id;
            }
        }
        reps.push_back(best);
    }
    std::cerr << "X orbit reps with nonzero B " << reps.size() << "\n";

    std::vector<int> cx, cz;
    std::vector<uint32_t> pivots;  // reduced rows, pivot bit is highest set bit
    Bits usedX, usedZ;
    uint64_t nodes = 0;
    int best = 0;
    bool found = false;

    auto in_span = [&](uint32_t v) {
        for (uint32_t row : pivots) {
            uint32_t p = 31 - __builtin_clz(row);
            if ((v >> p) & 1u) v ^= row;
        }
        return v == 0;
    };
    auto add_pivot = [&](uint32_t v) {
        for (uint32_t row : pivots) {
            uint32_t p = 31 - __builtin_clz(row);
            if ((v >> p) & 1u) v ^= row;
        }
        uint32_t p = 31 - __builtin_clz(v);
        for (uint32_t& row : pivots) {
            if ((row >> p) & 1u) row ^= v;
        }
        pivots.push_back(v);
    };

    auto seeds_of = [&](U v) {
        int m = 0;
        for (int s = 0; s < 8; s++) if ((v >> (16 * s)) & 0xffffu) m |= 1 << s;
        return m;
    };
    std::function<void()> rec = [&]() {
        if (found) return;
        nodes++;
        int k = (int)cx.size();
        if (k > best) {
            best = k;
            std::cerr << "best " << best << " nodes " << nodes << " xseeds";
            for (int i : cx) std::cerr << " " << seeds_of(X[i]);
            std::cerr << "\n";
        }
        if (k == 32) {
            found = true;
            std::cout << "FOUND\n";
            for (int t = 0; t < 32; t++) std::cout << cx[t] << " " << cz[t] << "\n";
            return;
        }
        if (nodes > limit) return;

        Bits allowed;
        allowed.fill(nX);
        for (int j : cz) allowed &= xOrthZ[j];
        for (int i : cx) allowed.reset(i);

        int pick = -1, pickc = 1 << 30;
        Bits pickz;
        auto consider = [&](int i) {
            if (!allowed.test(i) || !XB[i] || in_span(XB[i])) return;
            Bits zs = anti[i];
            zs &= zB1[i];
            for (int t : cx) {
                zs &= zOrthX[t];
                zs &= zB0[t];
            }
            for (int j : cz) zs.reset(j);
            int c = zs.count();
            if (c && c < pickc) {
                pickc = c;
                pick = i;
                pickz = zs;
            }
        };
        allowed.each(consider);
        if (pick < 0) return;
        uint32_t saved_n = (uint32_t)pivots.size();
        add_pivot(XB[pick]);
        cx.push_back(pick);
        pickz.each([&](int j) {
            if (found || nodes > limit) return;
            cz.push_back(j);
            rec();
            cz.pop_back();
        });
        cx.pop_back();
        pivots.resize(saved_n);
    };

    for (int ri = 0; ri < (int)reps.size() && !found && nodes <= limit; ri++) {
        int rep = reps[ri];
        uint64_t before = nodes;
        Bits zs = anti[rep];
        zs &= zB1[rep];
        int started = 0;
        zs.each([&](int j) {
            if (found || nodes > limit) return;
            cx.push_back(rep);
            cz.push_back(j);
            pivots.clear();
            add_pivot(XB[rep]);
            rec();
            cx.pop_back();
            cz.pop_back();
            pivots.clear();
            started++;
        });
        std::cerr << "rep " << ri << "/" << reps.size() << " index " << rep
                  << " partners " << started << " best " << best
                  << " nodes " << (nodes - before) << "\n";
    }
    std::cerr << (found ? "solved" : "exhausted_or_capped") << " best " << best << " nodes " << nodes << "\n";
    return found ? 0 : 2;
}
