// Exact span test for the block-identity obstruction.
//
// Logical coordinates are 128-bit vectors, eight seeds of 16 bits, low seed first.
// Block B is seeds 4 and 5. A CSS canonical frame is a dual pair of pool bases, so
// sum_j beta_j alpha_j^T = I_128. Restricting the input to block B, the selected
// pairs must satisfy sum_j beta_j (alpha restricted to B)^T = J_B, where J_B is
// the inclusion of the 32 B-coordinates into F_2^128. Pairs with alpha_B = 0
// contribute nothing. This program decides whether J_B lies in the F_2-span of
// those rank-at-most-1 updates, ignoring the matching constraint. Failure is a
// proof that no width-16 CSS canonical frame exists in these pools. Success is
// only a necessary condition.
//
// Build: c++ -O3 -std=c++17 b_identity_span.cpp -o b_identity_span
// Run:   ./b_identity_span xcoords.txt zcoords.txt [certificate.txt]

#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

using U = unsigned __int128;

static int pop2(uint64_t x) { return __builtin_popcountll(x); }

static int dot(U a, U b) {
    return (pop2((uint64_t)a & (uint64_t)b) + pop2((uint64_t)(a >> 64) & (uint64_t)(b >> 64))) & 1;
}

static std::vector<U> load(const std::string& path) {
    std::ifstream in(path);
    if (!in) {
        std::cerr << "cannot read " << path << "\n";
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

// Column is a 128 x 32 matrix over F_2, row-major, 32-bit rows.
// Bit r*32+c is row r, column c.
struct Col {
    uint64_t w[64]{};
    bool operator==(const Col& o) const {
        for (int i = 0; i < 64; i++) if (w[i] != o.w[i]) return false;
        return true;
    }
    void xor_with(const Col& o) {
        for (int i = 0; i < 64; i++) w[i] ^= o.w[i];
    }
    int lead() const {
        for (int i = 63; i >= 0; --i) if (w[i]) return i * 64 + 63 - __builtin_clzll(w[i]);
        return -1;
    }
};

struct ColHash {
    size_t operator()(const Col& c) const {
        uint64_t h = 0;
        for (int i = 0; i < 64; i++) h ^= c.w[i] + 0x9e3779b97f4a7c15ULL + (h << 6) + (h >> 2);
        return (size_t)h;
    }
};

static Col outer_full(U beta, uint32_t alpha_b) {
    Col c;
    // beta bit r (0 = least significant = coordinate 0) contributes alpha_b into row r.
    for (int half = 0; half < 2; half++) {
        uint64_t bits = (uint64_t)(beta >> (64 * half));
        while (bits) {
            int b = __builtin_ctzll(bits);
            int row = half * 64 + b;
            int bit = row * 32;
            // write the 32-bit word alpha_b at bit position `bit`
            int word = bit >> 6;
            int off = bit & 63;
            c.w[word] ^= (uint64_t)alpha_b << off;
            if (off) c.w[word + 1] ^= (uint64_t)alpha_b >> (64 - off);
            bits &= bits - 1;
        }
    }
    return c;
}

static Col inclusion_B() {
    // Rows 64..95 (seeds 4 and 5) form I_32. Coordinate r has bit 1<<r in the U layout,
    // which is the least-significant-bit numbering used by the hex loader.
    Col c;
    for (int i = 0; i < 32; i++) {
        int row = 64 + i;
        int bit = row * 32 + i;
        c.w[bit >> 6] ^= 1ULL << (bit & 63);
    }
    return c;
}

int main(int argc, char** argv) {
    if (argc < 3) {
        std::cerr << "usage: b_identity_span xcoords.txt zcoords.txt [certificate.txt]\n";
        return 1;
    }
    auto X = load(argv[1]);
    auto Z = load(argv[2]);
    const U Bmask = ((U)0xffffffffULL) << 64;  // bits 64..95
    std::unordered_map<Col, int, ColHash> seen;
    seen.reserve(1 << 16);
    int pairs = 0, nonzero = 0;
    for (U a : X) {
        uint32_t ab = (uint32_t)((a >> 64) & 0xffffffffULL);
        if (!ab) continue;
        for (U b : Z) {
            if (!dot(a, b)) continue;
            pairs++;
            if ((b & Bmask) == 0 && true) {
                // still contributes through the A and C rows of beta
            }
            Col col = outer_full(b, ab);
            nonzero++;
            seen.emplace(col, 1);
        }
    }
    // Also count both-B-nonzero pairs, the smaller model used by the earlier CP-SAT run.
    int both = 0;
    for (U a : X) {
        uint32_t ab = (uint32_t)((a >> 64) & 0xffffffffULL);
        if (!ab) continue;
        for (U b : Z) {
            if ((b & Bmask) == 0) continue;
            if (dot(a, b)) both++;
        }
    }
    std::cerr << "X " << X.size() << " Z " << Z.size()
              << " anticommuting pairs with alpha_B nonzero " << nonzero
              << " distinct columns " << seen.size()
              << " both-B-nonzero pairs " << both << "\n";

    // Echelon basis, keyed by the highest set bit of each row.
    std::vector<Col> pivot_row(4096);
    std::vector<char> has_pivot(4096);
    auto reduce = [&](Col r) {
        while (true) {
            int lead = r.lead();
            if (lead < 0 || !has_pivot[lead]) return r;
            r.xor_with(pivot_row[lead]);
        }
    };
    int rank = 0;
    for (const auto& kv : seen) {
        Col r = reduce(kv.first);
        int lead = r.lead();
        if (lead < 0) continue;
        // Clear this new pivot bit from earlier rows so each pivot bit lives in one row.
        for (int bit = lead + 1; bit < 4096; bit++) {
            if (!has_pivot[bit]) continue;
            if ((pivot_row[bit].w[lead >> 6] >> (lead & 63)) & 1ULL) pivot_row[bit].xor_with(r);
        }
        pivot_row[lead] = r;
        has_pivot[lead] = 1;
        rank++;
    }
    std::cerr << "span rank " << rank << " / 4096\n";

    // Sanity: sixteen seed-5 monomials, if present on both sides and anticommuting
    // with themselves, must put the seed-5 coordinate projection into the span.
    int mono_pairs = 0;
    for (int p = 0; p < 16; p++) {
        U e = (U)1 << (80 + p);
        bool xin = false, zin = false;
        for (U a : X) if (a == e) xin = true;
        for (U b : Z) if (b == e) zin = true;
        if (xin && zin) mono_pairs++;
    }
    std::cerr << "seed-5 monomials on both sides " << mono_pairs << "\n";

    Col target = inclusion_B();
    Col rem = reduce(target);
    if (rem.lead() >= 0) {
        std::cout << "J_B not in span\n";
        std::cout << "obstruction-bit " << rem.lead() << "\n";
        if (argc >= 4) {
            std::ofstream out(argv[3]);
            out << "rank " << rank << "\n";
            out << "failed-bit " << rem.lead() << "\n";
            out << "basis-rows " << rank << "\n";
            for (int bit = 0; bit < 4096; bit++) if (has_pivot[bit]) {
                out << std::dec << bit << " ";
                for (int i = 0; i < 64; i++) out << std::hex << pivot_row[bit].w[i] << (i + 1 == 64 ? "\n" : " ");
            }
        }
        return 0;
    }
    std::cout << "J_B is in the span (necessary condition only)\n";
    return 0;
}
