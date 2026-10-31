// Test necessary propagation against every small full canonical frame.
#define main legacy_seed4_main
#include "../seed4_fifteen.cpp"
#undef main
#include "../quotient_fast.h"
#include "../quotient_prepared.h"
#include "../quotient_coloop.h"
#include <random>
#include "../forced_propagation.h"
int main(){
 std::mt19937 gen(20261027);int feasible=0,rejected=0,possible=0,frames=0;
 for(int trial=0;trial<6000;++trial){
  int n=2+gen()%4;std::vector<U>X,Z;
  for(unsigned v=1;v<(1u<<n);++v){if(gen()%3==0)X.push_back(v);if(gen()%3==0)Z.push_back(v);}
  if(rank_of(X)!=n||rank_of(Z)!=n)continue;
  ForcedPropagation fp(X,Z,n);Bits req;for(int i=0;i<(int)X.size();++i)if(gen()%7==0)req.set(i);
  auto r=fp.run(req);bool expected=false;std::vector<int>S;
  std::function<void(int)> rec=[&](int at){
   if((int)S.size()==n){Bits present;GE ge;for(int i:S){present.set(i);ge.insert(X[i]);}if(ge.n!=n||!ForcedPropagation::subset(req,present))return;
    unsigned flags=0;Bits partners;
    for(int j=0;j<(int)Z.size();++j){U z=Z[j];unsigned label=0;for(int k=0;k<n;++k)label|=dot(X[S[k]],z)<<k;if(label&&!(label&(label-1))){flags|=label;partners.set(j);}}
    if(flags==((1u<<n)-1)){
     expected=true;++frames;
     if(!r.possible || !ForcedPropagation::subset(present,r.x) || !ForcedPropagation::subset(partners,r.z) || !ForcedPropagation::subset(r.mx,present) || !ForcedPropagation::subset(r.mz,partners)){
      std::cerr<<"A full witness was pruned in trial "<<trial<<"\n";std::exit(3);
     }
    }return;}
   for(int i=at;i<(int)X.size();++i){S.push_back(i);rec(i+1);S.pop_back();}
  };rec(0);
  if(expected&&!r.possible){std::cerr<<"UNSOUND "<<trial<<" "<<r.reason<<"\n";return 1;}
  if(expected)++feasible;if(r.possible)++possible;else ++rejected;
 }
 std::cout<<"PASS necessary propagation: "<<feasible<<" feasible controls retained, "<<rejected<<" rejected, "<<possible<<" possible; all "<<frames<<" full witnesses retained\n";
 return feasible&&rejected?0:2;
}
