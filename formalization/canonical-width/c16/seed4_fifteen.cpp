// Exact search for a width-16 CSS frame that uses a prescribed set of the
// seed-4 X monomials. Bits set in omit_mask are left out; every other bit is
// paired with one of its three forced Z partners. Assignments whose orthogonal
// X pool spans the complementary space are searched for a dual basis of the
// quotient. The search branches on the rarest surviving X coordinate. A branch
// dies when the pairs already chosen, together with the surviving pool, cannot
// span the quotient.
//
//   g++ -O3 -std=c++17 seed4_fifteen.cpp -o seed4_fifteen
//   ./seed4_fifteen pools/xcoords.txt pools/zcoords.txt [cap] [omit_mask]
//   ./seed4_fifteen --batch pools/xcoords.txt pools/zcoords.txt cap < types.txt
// cap 0 ranks the pools and does not search. A type string uses * for an
// omitted bit and 0,1,2 for the partner.
#include <algorithm>
#include <array>
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
static int lead(U v) {
    if (v >> 64) return 127 - __builtin_clzll((uint64_t)(v >> 64));
    return 63 - __builtin_clzll((uint64_t)v);
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

struct Bits {
    static constexpr int NW = 16;  // 1024 indices; the pools have 720 vectors
    uint64_t w[NW]{};
    void clear() {
        for (int i = 0; i < NW; i++) w[i] = 0;
    }
    void set(int i) { w[i >> 6] |= 1ull << (i & 63); }
    void reset(int i) { w[i >> 6] &= ~(1ull << (i & 63)); }
    int test(int i) const { return (int)((w[i >> 6] >> (i & 63)) & 1); }
    void fill(int n) {
        clear();
        for (int i = 0; i < n; i++) set(i);
    }
    void keep(const Bits& o) {
        for (int i = 0; i < NW; i++) w[i] &= o.w[i];
    }
    void exclude(const Bits& o) {
        for (int i = 0; i < NW; i++) w[i] &= ~o.w[i];
    }
    int count() const {
        int c = 0;
        for (int i = 0; i < NW; i++) c += pop2(w[i]);
        return c;
    }
    template <class F>
    void each(F f) const {
        for (int k = 0; k < NW; k++) {
            uint64_t m = w[k];
            while (m) {
                int b = __builtin_ctzll(m);
                f((k << 6) + b);
                m &= m - 1;
            }
        }
    }
};

static int ctz128(U v) {
    uint64_t lo = (uint64_t)v;
    if (lo) return __builtin_ctzll(lo);
    return 64 + __builtin_ctzll((uint64_t)(v >> 64));
}

// Echelon basis on lowest-bit pivots. Rank only; pivot rows stay triangular.
struct GE {
    U p[128]{};
    int n = 0;
    bool insert(U v) {
        while (v) {
            int b = ctz128(v);
            if (p[b]) v ^= p[b];
            else {
                p[b] = v;
                n++;
                return true;
            }
        }
        return false;
    }
};

static int extend_rank(const U* vecs, const Bits& avail, GE g, int atleast) {
    int extra = 0;
    for (int w = 0; w < Bits::NW && extra < atleast; w++) {
        uint64_t m = avail.w[w];
        while (m && extra < atleast) {
            int i = (w << 6) + __builtin_ctzll(m);
            m &= m - 1;
            if (g.insert(vecs[i])) extra++;
        }
    }
    return extra;
}

// Search a `need`-pair dual basis of the span of X (and of Z). Returns true
// if one exists. `nodes` counts recursive calls and stops after `cap`. A
// capped search returns false and sets `capped`.
//
// Completeness of the branch: every still-available X vector is independent
// of the pairs already chosen, because it commutes with every chosen Z. If a
// coordinate is set on any available vector, no completion can avoid it. An
// avoiding completion would be a dual basis of the quotient in which every
// available vector reduces into the zero-coordinate hyperplane, hence would
// have 0 on that coordinate. Trying each available vector that carries the
// rarest such coordinate, with each surviving anticommuting Z, is enough.
static bool complete(const std::vector<U>& Xv, const std::vector<U>& Zv, int need, uint64_t cap,
                     uint64_t& nodes, bool& capped, std::vector<std::pair<int, int>>* out) {
    const int nX = (int)Xv.size(), nZ = (int)Zv.size();
    if (nX > Bits::NW * 64 || nZ > Bits::NW * 64) {
        std::cerr << "pool exceeds bitset capacity\n";
        std::exit(1);
    }
    if (need > 128) return false;
    std::vector<U> Xstor = Xv, Zstor = Zv;
    const U* X = Xstor.data();
    const U* Z = Zstor.data();
    std::vector<Bits> xAnti(nX), zAnti(nZ);
    for (int i = 0; i < nX; i++)
        for (int j = 0; j < nZ; j++)
            if (dot(X[i], Z[j])) {
                xAnti[i].set(j);
                zAnti[j].set(i);
            }
    Bits availX, availZ;
    availX.fill(nX);
    availZ.fill(nZ);
    capped = false;
    struct Search {
        const U* X;
        const U* Z;
        const Bits* xAnti;
        const Bits* zAnti;
        int nX, nZ, need;
        uint64_t cap;
        uint64_t* nodes;
        bool* capped;
        std::vector<std::pair<int, int>>* out;
        bool found = false;
        int cx[128]{}, cz[128]{};
        void rec(GE gx, GE gz, Bits ax, Bits az, int k) {
            if (*nodes >= cap) {
                *capped = true;
                return;
            }
            uint64_t nd = ++(*nodes);
            if ((nd & 262143ull) == 0)
                std::cerr << "progress nodes " << nd << " depth " << k << "\n";
            if (found) return;
            if (k == need) {
                found = true;
                if (out) {
                    out->clear();
                    for (int t = 0; t < need; t++) out->push_back({cx[t], cz[t]});
                }
                return;
            }
            int left = need - k;
            if (ax.count() < left || az.count() < left) return;
            // Survivors must extend the chosen pairs all the way to the quotient.
            if (extend_rank(X, ax, gx, left) < left) return;
            if (extend_rank(Z, az, gz, left) < left) return;
            int hits[128] = {};
            ax.each([&](int i) {
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
            ax.each([&](int i) {
                if ((X[i] >> bstar) & 1) cands.push_back(i);
            });
            for (int i : cands) {
                if (found || *capped) return;
                Bits zs = xAnti[i];
                zs.keep(az);
                zs.each([&](int j) {
                    if (found || *capped) return;
                    Bits nx = ax, nz = az;
                    nx.reset(i);
                    nz.reset(j);
                    nx.exclude(zAnti[j]);
                    nz.exclude(xAnti[i]);
                    if (nx.count() < left - 1 || nz.count() < left - 1) return;
                    GE ngx = gx, ngz = gz;
                    if (!ngx.insert(X[i]) || !ngz.insert(Z[j])) return;
                    cx[k] = i;
                    cz[k] = j;
                    rec(ngx, ngz, nx, nz, k + 1);
                });
            }
        }
    };
    Search s{X, Z, xAnti.data(), zAnti.data(), nX, nZ, need, cap, &nodes, &capped, out};
    s.rec(GE{}, GE{}, availX, availZ, 0);
    return s.found;
}

static bool self_test() {
    std::vector<U> X, Z;
    for (int i = 0; i < 6; i++) {
        X.push_back((U)1 << i);
        Z.push_back((U)1 << i);
    }
    X.push_back(3);  // e0+e1, extra
    uint64_t nodes = 0;
    bool capped = false;
    std::vector<std::pair<int, int>> sol;
    bool ok = complete(X, Z, 6, 100000, nodes, capped, &sol);
    if (!ok || capped || (int)sol.size() != 6) {
        std::cerr << "self-test positive failed nodes " << nodes << "\n";
        return false;
    }
    // Check the planted pairs really multiply to I.
    std::vector<U> xs, zs;
    for (auto [i, j] : sol) {
        xs.push_back(X[i]);
        zs.push_back(Z[j]);
    }
    for (int a = 0; a < 6; a++)
        for (int b = 0; b < 6; b++)
            if (dot(xs[a], zs[b]) != (a == b)) {
                std::cerr << "self-test gram failed\n";
                return false;
            }
    // Negative: drop one Z basis vector and the extra is not a replacement dual.
    Z.pop_back();  // remove e5; only 5 Z left but wait we popped the last which is e5, X still has 7
    // Z now has e0..e4 only. Rank 5 < 6.
    nodes = 0;
    capped = false;
    if (complete(X, Z, 6, 100000, nodes, capped, nullptr)) {
        std::cerr << "self-test negative failed\n";
        return false;
    }
    std::cerr << "self-test ok\n";
    return true;
}

static int batch_main(int argc, char** argv) {
    if (argc < 4) {
        std::cerr << "usage: seed4_fifteen --batch xcoords zcoords cap < types.txt\n";
        return 1;
    }
    auto Xall = load(argv[2]);
    auto Zall = load(argv[3]);
    uint64_t cap = std::strtoull(argv[4], nullptr, 10);
    U xs4 = 0;
    for (U a : Xall)
        if (((a >> 64) & 0xffffffffu) == 1) xs4 = a;
    std::vector<U> proto;
    for (U b : Zall)
        if ((((b >> 64) & 0xffffu) == 1) && dot(xs4, b)) proto.push_back(b);
    if (proto.size() != 3) return 1;
    std::string line;
    uint64_t nfound = 0, ndead = 0, ncapped = 0, nshort = 0;
    while (std::cin >> line) {
        if (line.size() != 16) continue;
        std::vector<U> partners, rows, Zel;
        int nKeep = 0, keptMask = 0;
        for (int p = 0; p < 16; p++) {
            if (line[p] == '*') continue;
            if (line[p] < '0' || line[p] > '2') {
                std::cerr << "bad " << line << "\n";
                return 1;
            }
            nKeep++;
            keptMask |= 1 << p;
            partners.push_back(rot(proto[line[p] - '0'], p));
        }
        for (U a : Xall) {
            bool ok = true;
            for (U b : partners)
                if (dot(a, b)) {
                    ok = false;
                    break;
                }
            if (ok) rows.push_back(a);
        }
        for (U b : Zall)
            if ((((b >> 64) & 0xffffu) & keptMask) == 0) Zel.push_back(b);
        int need = 128 - nKeep;
        int rx = rank_of(rows), rz = rank_of(Zel);
        if (rx < need || rz < need) {
            nshort++;
            std::cout << "SHORT " << line << " X " << rows.size() << " " << rx << " Z " << Zel.size() << " " << rz
                      << "\n";
            continue;
        }
        uint64_t nodes = 0;
        bool capped = false;
        bool ok = complete(rows, Zel, need, cap, nodes, capped, nullptr);
        if (ok) {
            nfound++;
            std::cout << "FOUND " << line << " nodes " << nodes << "\n";
        } else if (capped) {
            ncapped++;
            std::cout << "CAPPED " << line << " nodes " << nodes << "\n";
        } else {
            ndead++;
            std::cout << "DEAD " << line << " nodes " << nodes << "\n";
        }
    }
    std::cout << "batch found " << nfound << " dead " << ndead << " capped " << ncapped << " short " << nshort
              << "\n";
    return nfound ? 0 : (ncapped ? 2 : 3);
}

int main(int argc, char** argv) {
    if (argc >= 2 && std::string(argv[1]) == "--batch") return batch_main(argc, argv);
    if (!self_test()) return 1;
    if (argc < 3) {
        std::cerr << "usage: seed4_fifteen xcoords zcoords [per_instance_node_cap] [omit_mask]\n";
        std::cerr << "omit_mask bit i set => seed-4 monomial i is not in the frame (default 1).\n";
        std::cerr << "cap 0 ranks the orthogonal pools and does not search the quotient.\n";
        return 1;
    }
    auto Xall = load(argv[1]);
    auto Zall = load(argv[2]);
    uint64_t cap = argc > 3 ? std::strtoull(argv[3], nullptr, 10) : 200000ull;
    int omitMask = argc > 4 ? (int)std::strtol(argv[4], nullptr, 0) : 1;
    if (omitMask <= 0 || omitMask >= (1 << 16)) {
        std::cerr << "omit_mask out of range\n";
        return 1;
    }
    U xs4 = 0;
    for (U a : Xall)
        if (((a >> 64) & 0xffffffffu) == 1) xs4 = a;
    std::vector<U> proto;
    for (U b : Zall)
        if ((((b >> 64) & 0xffffu) == 1) && dot(xs4, b)) proto.push_back(b);
    if (proto.size() != 3) {
        std::cerr << "expected 3 protos, got " << proto.size() << "\n";
        return 1;
    }
    const int n = (int)Xall.size();
    // allowed[i][p] : bitmask of partner types at bit p that commute with X[i].
    std::vector<std::array<uint8_t, 16>> allowed(n);
    for (int i = 0; i < n; i++) {
        for (int p = 0; p < 16; p++) {
            uint8_t m = 0;
            for (int t = 0; t < 3; t++)
                if (!dot(Xall[i], rot(proto[t], p))) m |= (uint8_t)(1 << t);
            allowed[i][p] = m;
        }
    }
    std::vector<int> kept;
    int keptMask = 0;
    for (int p = 0; p < 16; p++)
        if ((omitMask & (1 << p)) == 0) {
            kept.push_back(p);
            keptMask |= 1 << p;
        }
    const int nKeep = (int)kept.size();
    const int need = 128 - nKeep;
    // Eligible Z: orthogonal to every kept seed-4 monomial, so the seed-4
    // support is contained in the omitted bits.
    std::vector<U> Zel;
    std::vector<int> zId;
    for (int j = 0; j < (int)Zall.size(); j++) {
        if ((((Zall[j] >> 64) & 0xffffu) & keptMask) == 0) {
            Zel.push_back(Zall[j]);
            zId.push_back(j);
        }
    }
    std::cerr << "omit " << omitMask << " kept " << nKeep << " need " << need << " eligible Z " << Zel.size()
              << " rank " << rank_of(Zel) << "\n";
    if (nKeep == 0 || nKeep > 16) return 1;

    std::vector<int> tz(nKeep, 0), rej(n, 0);
    for (int i = 0; i < n; i++)
        for (int k = 0; k < nKeep; k++)
            if ((allowed[i][kept[k]] & 1) == 0) rej[i]++;
    auto active_count = [&]() {
        int c = 0;
        for (int i = 0; i < n; i++)
            if (!rej[i]) c++;
        return c;
    };
    auto active_rows = [&]() {
        std::vector<U> rows;
        for (int i = 0; i < n; i++)
            if (!rej[i]) rows.push_back(Xall[i]);
        return rows;
    };
    auto type_string = [&]() {
        std::string s(16, '*');
        for (int k = 0; k < nKeep; k++) s[kept[k]] = char('0' + tz[k]);
        return s;
    };
    uint64_t seen = 0, full = 0, solved = 0, capped_n = 0, search_nodes = 0;
    int maxRank = 0;
    auto consider = [&]() {
        seen++;
        int cnt = active_count();
        if (cnt < need) return;
        auto rows = active_rows();
        int r = rank_of(rows);
        if (r > maxRank) maxRank = r;
        if (r < need) return;
        full++;
        std::cerr << "FULL " << type_string() << " X " << rows.size() << " rank " << r << "\n";
        if (cap == 0) return;
        uint64_t nodes = 0;
        bool capped = false;
        std::vector<std::pair<int, int>> sol;
        bool ok = complete(rows, Zel, need, cap, nodes, capped, &sol);
        search_nodes += nodes;
        if (ok) {
            solved++;
            std::cout << "FOUND types " << type_string() << "\n";
            std::vector<int> xLocal;
            for (int i = 0; i < n; i++)
                if (!rej[i]) xLocal.push_back(i);
            for (auto [a, b] : sol) std::cout << xLocal[a] << " " << zId[b] << "\n";
            std::exit(0);
        }
        if (capped) capped_n++;
        std::cerr << "dead " << type_string() << " nodes " << nodes << (capped ? " CAPPED" : "") << "\n";
    };
    consider();
    while (true) {
        int k = 0;
        while (k < nKeep && tz[k] == 2) {
            int p = kept[k];
            for (int i = 0; i < n; i++) {
                bool was = allowed[i][p] & (1 << 2);
                bool now = allowed[i][p] & 1;
                if (was && !now) rej[i]++;
                if (!was && now) rej[i]--;
            }
            tz[k] = 0;
            k++;
        }
        if (k == nKeep) break;
        int p = kept[k];
        int nw = tz[k] + 1;
        for (int i = 0; i < n; i++) {
            bool was = allowed[i][p] & (1 << tz[k]);
            bool now = allowed[i][p] & (1 << nw);
            if (was && !now) rej[i]++;
            if (!was && now) rej[i]--;
        }
        tz[k] = nw;
        consider();
        if ((seen & 0xfffff) == 0)
            std::cerr << "seen " << seen << " full " << full << " capped " << capped_n << " maxRank " << maxRank
                      << " search_nodes " << search_nodes << "\n";
    }
    uint64_t expect = 1;
    for (int i = 0; i < nKeep; i++) expect *= 3;
    std::cout << "omit " << omitMask << " seen " << seen << " expect " << expect << " full " << full
              << " solved " << solved << " capped " << capped_n << " maxRank " << maxRank
              << " need " << need << " search_nodes " << search_nodes << "\n";
    if (seen != expect) {
        std::cout << "COUNT_MISMATCH\n";
        return 1;
    }
    if (cap == 0) {
        std::cout << (maxRank < need ? "RANK_OBSTRUCTION" : "RANK_OPEN") << "\n";
        return 0;
    }
    if (capped_n) std::cout << "SEARCH_INCOMPLETE\n";
    else std::cout << "NO_FRAME\n";
    return capped_n ? 2 : 0;
}
