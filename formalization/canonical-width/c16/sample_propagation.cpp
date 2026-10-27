// Sample larger prescribed-X sets to compare rank-only and iterative pruning.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include "quotient_coloop.h"
#include "forced_propagation.h"
#include <random>
int main(int argc,char**argv){
 if(argc<4)return 1;auto X=load(argv[1]),Z=load(argv[2]);ForcedPropagation fp(X,Z,128);std::ofstream out(argv[3]);std::mt19937 rng(20261027);int count=argc>4?std::stoi(argv[4]):10000;
 for(int size=3;size<=8;++size){int basic=0,extra=0,possible=0;std::vector<int> example;
  for(int trial=0;trial<count;++trial){Bits req;while(req.count()<size)req.set(rng()%720);GE tx;req.each([&](int i){tx.insert(X[i]);});
   bool bad=tx.n!=size;Bits zero,eligible;for(int j=0;j<720;++j){int d=ForcedPropagation::overlap(fp.za[j],req);if(d==0)zero.set(j);if(d<=1)eligible.set(j);}
   if(extend_rank(Z.data(),zero,GE{},128-size)<128-size || extend_rank(Z.data(),eligible,GE{},128)<128)bad=true;
   if(bad){++basic;continue;}auto result=fp.run(req);
   if(!result.possible){++extra;std::vector<int>ids;req.each([&](int i){ids.push_back(i);});
    for(int i:ids){Bits test=req;test.reset(i);if(!fp.run(test).possible)req=test;}
    out<<"[";bool comma=false;req.each([&](int i){if(comma)out<<",";comma=true;out<<i;});out<<"]\n";
   }else ++possible;
  }
  std::cout<<"size "<<size<<" trials "<<count<<" basic_excluded "<<basic<<" propagation_extra "<<extra<<" unresolved "<<possible<<std::endl;
 }
}
