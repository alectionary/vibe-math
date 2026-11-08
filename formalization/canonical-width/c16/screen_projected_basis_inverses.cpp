// Reuse the established exact 128-bit inverse, then count duals in the X pool.
// This screens saved source bases only; a negative result excludes no new frame.
#define main inherited_climb_main
#include "search/climb_steep.cpp"
#undef main
#include <array>
#include <unordered_map>

int main(int argc, char** argv) {
    if (argc != 7) return 1;
    const auto X = load(argv[1]), Z = load(argv[2]);
    if (X.size() != 720 || Z.size() != 720) return 2;
    std::unordered_map<U, int, UHash> xindex;
    for (int i = 0; i < 720; ++i) xindex[X[i]] = i;
    if (xindex.size() != 720) return 3;
    std::ifstream input(argv[3], std::ios::binary);
    std::ofstream scores(argv[4], std::ios::binary);
    const uint64_t limit = std::stoull(argv[6]);
    uint64_t total = 0;
    input.read(reinterpret_cast<char*>(&total), sizeof(total));
    if (!input) return 4;
    const uint64_t wanted = limit ? std::min(limit, total) : total;
    std::array<uint64_t, 129> histogram{};
    std::vector<uint16_t> indices(128), best_indices;
    std::vector<U> columns(128), dual, best_dual;
    int best = -1;
    uint64_t best_row = 0, seen = 0;
    auto start = std::chrono::steady_clock::now();
    for (; seen < wanted; ++seen) {
        input.read(reinterpret_cast<char*>(indices.data()), 256);
        if (!input) return 5;
        for (int j = 0; j < 128; ++j) {
            if (indices[j] >= 720) return 6;
            columns[j] = Z[indices[j]];
        }
        if (!invert(columns, dual)) return 7;
        int count = 0;
        for (U x : dual) count += xindex.count(x);
        ++histogram[count];
        unsigned char value = count;
        scores.write(reinterpret_cast<const char*>(&value), 1);
        if (count > best) {
            for (int i = 0; i < 128; ++i)
                for (int j = 0; j < 128; ++j)
                    if (dot(dual[i], columns[j]) != (i == j)) return 8;
            best = count; best_row = seen; best_indices = indices; best_dual = dual;
            std::cout << "BEST " << best << " archive_row " << best_row << std::endl;
        }
    }
    if (!scores) return 9;
    const double elapsed = std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();
    std::ofstream out(argv[5]);
    out << "{\"status\":\"SAVED_BASIS_INVERSE_SCREEN_COMPLETE\",\"source_C16_answered\":false,\"input_rows\":" << total
        << ",\"rows_checked\":" << seen << ",\"entire_archive_checked\":" << (seen == total ? "true" : "false")
        << ",\"maximum_pool_duals\":" << best << ",\"best_archive_row\":" << best_row
        << ",\"elapsed_seconds\":" << elapsed << ",\"histogram\":[";
    for (int k = 0; k <= 128; ++k) out << (k ? "," : "") << histogram[k];
    out << "],\"best_Z_basis\":[";
    for (int k = 0; k < 128; ++k) out << (k ? "," : "") << best_indices[k];
    out << "],\"pool_pairs\":[";
    bool comma = false;
    for (int k = 0; k < 128; ++k) {
        const auto found = xindex.find(best_dual[k]);
        if (found != xindex.end()) {
            out << (comma ? "," : "") << "[" << found->second << "," << best_indices[k] << "]";
            comma = true;
        }
    }
    out << "]}\n";
    std::cout << "COMPLETE " << seen << " best " << best << " seconds " << elapsed << std::endl;
    return out ? 0 : 10;
}
