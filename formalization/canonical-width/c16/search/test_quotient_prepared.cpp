// Compare the quotient search with independent enumeration of X bases in
// small vector spaces. Used to test its branching and span-extension prune.
#define main legacy_seed4_main
#include "../seed4_fifteen.cpp"
#undef main
#include "../quotient_fast.h"
#include "../quotient_prepared.h"
#include <random>

static bool brute(const std::vector<U>& X,const std::vector<U>& Z,int n) {
    std::vector<int> chosen;
    std::function<bool(int)> rec=[&](int begin) {
        if((int)chosen.size()==n) {
            GE g;for(int i:chosen)g.insert(X[i]);if(g.n!=n)return false;
            unsigned flags=0;
            for(U z:Z) {
                unsigned label=0;
                for(int k=0;k<n;++k)label|=dot(X[chosen[k]],z)<<k;
                if(label && !(label&(label-1)))flags|=label;
            }
            return flags==((1u<<n)-1);
        }
        for(int i=begin;i<(int)X.size();++i) {
            chosen.push_back(i);if(rec(i+1))return true;chosen.pop_back();
        }
        return false;
    };
    return rec(0);
}

int main() {
    std::mt19937 gen(20261027);
    int positive=0,negative=0;
    for(int trial=0;trial<6000;++trial) {
        int n=2+gen()%4;
        std::vector<U> X,Z;
        for(unsigned v=1;v<(1u<<n);++v) {
            if(gen()%4==0)X.push_back(v);
            if(gen()%4==0)Z.push_back(v);
        }
        // The quotient routine is used only with the whole target span.
        if(rank_of(X)!=n || rank_of(Z)!=n)continue;
        bool expected=brute(X,Z,n);
        uint64_t nodes=0;bool capped=false;
        bool actual=fast_complete(X,Z,n,1000000,nodes,capped,nullptr);
        uint64_t nodes2=0;bool capped2=false;
        bool actual2=fast_complete(X,Z,n,1000000,nodes2,capped2,nullptr,false);
        if(capped2 || actual2!=expected)return 2;
        PreparedQuotient prepared(X,Z);Bits aa,bb;aa.fill(X.size());bb.fill(Z.size());
        uint64_t nodes3=0;bool capped3=false;
        bool actual3=prepared.complete(aa,bb,n,1000000,nodes3,capped3,nullptr);
        if(capped3 || actual3!=expected || nodes3!=nodes)return 3;
        if(capped || actual!=expected){std::cerr<<"FAIL trial "<<trial<<"\n";return 1;}
        (actual?positive:negative)++;
    }
    std::cout<<"independent brute-force agreement: "<<positive<<" positive, "
             <<negative<<" negative full-rank instances\n";
    return positive && negative ? 0 : 1;
}
