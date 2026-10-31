// Exhaustively compare the monomial-count prune on small embedded spaces.
#define main legacy_seed4_main
#include "../seed4_fifteen.cpp"
#undef main
#include "../quotient_fast.h"
#include "../quotient_prepared.h"
#include <chrono>
#include "../quotient_bounded.h"
#include <random>
int main(){std::mt19937 gen(20261027);int positive=0,negative=0;
 for(int trial=0;trial<5000;++trial){int n=2+gen()%4,bound=gen()%(n+1);std::vector<U>X,Z;
  for(int v=1;v<(1<<n);++v){if(gen()%3==0)X.push_back(U(v)<<64);if(gen()%3==0)Z.push_back(U(v)<<64);}
  if(rank_of(X)!=n||rank_of(Z)!=n)continue;bool expected=false;std::vector<int> chosen;
  std::function<void(int)> rec=[&](int begin){if(expected)return;if((int)chosen.size()==n){GE g;int mono=0;for(int i:chosen){g.insert(X[i]);if(__builtin_popcountll(uint64_t(X[i]>>64))==1)++mono;}if(g.n<n||mono>bound)return;
   unsigned flags=0;for(U z:Z){unsigned label=0;for(int k=0;k<n;++k)label|=dot(X[chosen[k]],z)<<k;if(label&&!(label&(label-1)))flags|=label;}if(flags==((1u<<n)-1))expected=true;return;}
   for(int i=begin;i<(int)X.size();++i){chosen.push_back(i);rec(i+1);chosen.pop_back();}};rec(0);
  BoundedQuotient q(X,Z);q.max_seed4=bound;Bits a,b;a.fill(X.size());b.fill(Z.size());uint64_t nodes=0;bool capped=false;bool actual=q.complete(a,b,n,1000000,nodes,capped,nullptr);
  if(capped||actual!=expected){std::cerr<<"FAIL "<<trial<<" bound "<<bound<<"\n";return 1;}(actual?positive:negative)++;
 }
 std::cout<<"PASS bounded quotient: "<<positive<<" positive, "<<negative<<" negative exhaustive controls\n";return positive&&negative?0:2;
}
