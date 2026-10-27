// Complete partner-domain search. Unlike seed4_fifteen.cpp, the partner's
// seed-4 block need only restrict to e_p on the KEPT bits. It may contain
// any omitted bits. Pool indices in FOUND output are zero-based.
// Uses the partitioned, bidirectional quotient search in quotient_fast.h.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include <chrono>
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include <sstream>

static int partners_main(int argc,char** argv) {
    if(argc<5)return 1;
    auto X=load(argv[2]),Z=load(argv[3]);PreparedQuotient prepared(X,Z);uint64_t cap=std::strtoull(argv[4],nullptr,0);
    std::string line;int index=0,ncapped=0;
    while(std::getline(std::cin,line)) {
        auto start=std::chrono::steady_clock::now();
        size_t at=line.find("partners");if(at!=std::string::npos)line=line.substr(at+8);
        std::istringstream in(line);std::string token;std::vector<int> chosen(16,-1),xid,zid;
        unsigned kept=0;std::vector<U> forced,rows,eligible;
        while(in>>token){size_t colon=token.find(':');if(colon==std::string::npos)continue;
            int p=std::stoi(token.substr(0,colon)),j=std::stoi(token.substr(colon+1));
            if(p<0 || p>=16 || j<0 || j>=(int)Z.size() || chosen[p]>=0)return 1;
            chosen[p]=j;kept|=1u<<p;forced.push_back(Z[j]);
        }
        if(!kept)continue;++index;
        for(int p=0;p<16;++p)if(chosen[p]>=0)
            if(((unsigned)(Z[chosen[p]]>>64)&kept)!=(1u<<p))return 1;
        for(int i=0;i<(int)X.size();++i){bool ok=true;for(U z:forced)if(dot(X[i],z)){ok=false;break;}
            if(ok){rows.push_back(X[i]);xid.push_back(i);}}
        for(int j=0;j<(int)Z.size();++j)if(((unsigned)(Z[j]>>64)&kept)==0){eligible.push_back(Z[j]);zid.push_back(j);}
        uint64_t nodes=0;bool capped=false;std::vector<std::pair<int,int>> sol;
        Bits aa,bb;for(int i:xid)aa.set(i);for(int j:zid)bb.set(j);
        bool ok=prepared.complete(aa,bb,128-pop2(kept),cap,nodes,capped,&sol);
        if(capped)++ncapped;
        std::cout<<"RESULT "<<index<<" "<<(ok?"FOUND":capped?"CAPPED":"DEAD")<<" nodes "<<nodes
                 <<" seconds "<<std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count()<<" partners";
        for(int p=0;p<16;++p)if(chosen[p]>=0)std::cout<<" "<<p<<":"<<chosen[p];std::cout<<std::endl;
        if(ok){
            std::vector<std::pair<int,int>> all;
            for(int p=0;p<16;++p)if(chosen[p]>=0){
                int found=-1;for(int i=0;i<(int)X.size();++i)if(X[i]==(U(1)<<(64+p)))found=i;
                if(found<0)return 1;all.push_back({found,chosen[p]});}
            for(auto[i,j]:sol)all.push_back({i,j});
            if(all.size()!=128)return 1;
            for(int a=0;a<128;++a)for(int b=0;b<128;++b)
                if(dot(X[all[a].first],Z[all[b].second])!=(a==b))return 1;
            for(auto[i,j]:all)std::cout<<"PAIR "<<i<<" "<<j<<"\n";
            return 0;
        }
    }
    return ncapped?2:3;
}

int main(int argc, char** argv) {
    if(argc>=2 && std::string(argv[1])=="--partners")return partners_main(argc,argv);
    if (argc < 4) {
        std::cerr << "usage: seed4_exact xcoords zcoords omit_mask [quotient_cap]\n";
        return 1;
    }
    auto X = load(argv[1]), Z = load(argv[2]);
    PreparedQuotient prepared(X,Z);
    unsigned omitted = std::strtoul(argv[3], nullptr, 0);
    if (omitted >= 65536 || omitted == 65535) return 1;
    unsigned kept = 65535 ^ omitted;
    uint64_t cap = argc > 4 ? std::strtoull(argv[4], nullptr, 0) : 1000000;
    int m = pop2(kept), need = 128-m;
    std::vector<int> positions, chosen(16,-1), monomial(16,-1), zid;
    std::vector<std::vector<int>> domains(16);
    std::vector<Bits> commute(Z.size());
    std::vector<U> eligibleZ;
    uint64_t total = 1;
    for (int p = 0; p < 16; ++p) if (kept & (1u << p)) {
        positions.push_back(p);
        for (int i = 0; i < (int)X.size(); ++i)
            if (X[i] == (U(1) << (64+p))) monomial[p] = i;
        if (monomial[p] < 0) return 1;
        for (int j = 0; j < (int)Z.size(); ++j)
            if (((unsigned)(Z[j] >> 64) & kept) == (1u << p)) domains[p].push_back(j);
        std::cout << "domain " << p << " size " << domains[p].size() << " ids";
        for (int j : domains[p]) std::cout << " " << j;
        std::cout << "\n";
        total *= domains[p].size();
    }
    for (int j = 0; j < (int)Z.size(); ++j) {
        for (int i = 0; i < (int)X.size(); ++i)
            if (!dot(X[i], Z[j])) commute[j].set(i);
        if (((unsigned)(Z[j] >> 64) & kept) == 0) {
            eligibleZ.push_back(Z[j]); zid.push_back(j);
        }
    }
    std::sort(positions.begin(), positions.end(), [&](int a, int b) {
        return domains[a].size() != domains[b].size() ? domains[a].size() < domains[b].size() : a < b;
    });
    std::vector<uint64_t> suffix(m+1,1);
    for (int k=m-1; k>=0; --k) suffix[k]=suffix[k+1]*domains[positions[k]].size();
    Bits eligibleBits;for(int j:zid)eligibleBits.set(j);
    uint64_t visited=0, covered=0, pruned=0, full=0, dead=0, cappedCount=0, nodesTotal=0;
    auto start = std::chrono::steady_clock::now();
    bool found=false;
    std::function<void(int,Bits)> rec = [&](int depth, Bits active) {
        if (found) return;
        ++visited;
        // The depth already-fixed monomial/partner pairs force the other
        // 128-depth X basis vectors to lie in this surviving pool. Requiring
        // only the final quotient dimension 128-m misses this stronger prefix
        // obstruction. Every completion must span the WHOLE current kernel.
        int prefix_need=128-depth;
        if (active.count() < prefix_need || (depth >= 2 && extend_rank(X.data(),active,GE{},prefix_need) < prefix_need)) {
            covered += suffix[depth]; ++pruned; return;
        }
        if (depth == m) {
            ++covered; ++full;
            if (!cap) return;
            uint64_t nodes=0; bool capped=false;
            std::vector<std::pair<int,int>> solution;
            bool ok=prepared.complete(active,eligibleBits,need,cap,nodes,capped,&solution);
            nodesTotal+=nodes;
            if (ok) {
                found=true;
                std::cout << "FOUND " << m << " forced and " << need << " quotient pairs\n";
                for (int p : positions) std::cout << "PAIR " << monomial[p] << " " << chosen[p] << "\n";
                for (auto [i,j] : solution) std::cout << "PAIR " << i << " " << j << "\n";
            } else {
                if (capped) ++cappedCount; else ++dead;
                if (capped) {
                    std::cout << "CAPPED nodes " << nodes << " partners";
                    for (int p : positions) std::cout << " " << p << ":" << chosen[p];
                    std::cout << std::endl;
                }
            }
            if ((full & 1023)==0) std::cerr << "full " << full << " covered " << covered << "/" << total
                << " capped " << cappedCount << " nodes " << nodesTotal << "\n";
            return;
        }
        int p=positions[depth];
        for (int j : domains[p]) {
            chosen[p]=j;
            Bits next=active; next.keep(commute[j]); rec(depth+1,next);
            if (found) return;
        }
    };
    Bits all; all.fill(X.size());
    rec(0,all);
    double seconds=std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();
    std::cout << "SUMMARY omitted " << omitted << " kept " << m << " total " << total
              << " covered " << covered << " visited " << visited << " pruned " << pruned
              << " full " << full << " dead " << dead << " capped " << cappedCount
              << " nodes " << nodesTotal << " seconds " << seconds << std::endl;
    if (found) return 0;
    if (covered != total) return 1;
    if (!cap) { std::cout << "RANK_SCAN_ONLY\n"; return 0; }
    std::cout << (cappedCount ? "INCOMPLETE\n" : "NO_FRAME\n");
    return cappedCount ? 2 : 3;
}
