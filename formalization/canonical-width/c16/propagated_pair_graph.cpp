// Necessary X-basis compatibility: for two selected X vectors, the Z pool
// orthogonal to both must span their 126-dimensional common kernel.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include "quotient_coloop.h"
#include "forced_propagation.h"
int main(int argc,char**argv){
    if(argc<3)return 1;auto X=load(argv[1]),Z=load(argv[2]);
    if(X.size()!=720 || Z.size()!=720)return 1;
    std::vector<Bits> zero(720),graph(720);
    for(int i=0;i<720;++i)for(int j=0;j<720;++j)if(!dot(X[i],Z[j]))zero[i].set(j);
    uint64_t good=0,bad=0;int minrank=128;ForcedPropagation fp(X,Z,128);std::ofstream negatives(argc>4?argv[4]:"/tmp/c16-propagation-pairs.txt");
    for(int a=0;a<45;++a)for(int b=a;b<45;++b)for(int h=(a==b?1:0);h<(a==b?9:16);++h){
        Bits required;required.set(16*a);required.set(16*b+h);auto result=fp.run(required);
        if(!result.possible){++bad;negatives<<16*a<<" "<<16*b+h<<" "<<result.reason<<" "<<result.rounds<<"\n";continue;}++good;
        for(int k=0;k<16;++k){int i=16*a+k,j=16*b+((h+k)%16);graph[i].set(j);graph[j].set(i);}
    }
    uint64_t edges=0;for(auto&g:graph)edges+=g.count();edges/=2;
    std::cout<<"propagated_pair_orbits_good "<<good<<" bad "<<bad<<" min_rank "<<minrank<<" edges "<<edges<<"\n";
    // Deterministic DSATUR coloring; verified against every graph edge.
    int colors[720];std::fill(colors,colors+720,-1);int used=0;
    for(int k=0;k<720;++k){int best=-1,sat=-1,degree=-1;
        for(int i=0;i<720;++i)if(colors[i]<0){std::vector<char> seen(720);int s=0;
            graph[i].each([&](int j){if(colors[j]>=0 && !seen[colors[j]]){seen[colors[j]]=1;++s;}});
            int d=graph[i].count();if(s>sat || (s==sat && d>degree)){best=i;sat=s;degree=d;}}
        std::vector<char> seen(720);graph[best].each([&](int j){if(colors[j]>=0)seen[colors[j]]=1;});
        int c=0;while(seen[c])++c;colors[best]=c;used=std::max(used,c+1);
    }
    for(int i=0;i<720;++i)graph[i].each([&](int j){if(colors[i]==colors[j])std::exit(2);});
    std::cout<<"verified_colors "<<used<<"\n";
    if(argc>3){std::ofstream out(argv[3]);for(int i=0;i<720;++i){out<<i<<" "<<colors[i];graph[i].each([&](int j){out<<" "<<j;});out<<"\n";}}
}
