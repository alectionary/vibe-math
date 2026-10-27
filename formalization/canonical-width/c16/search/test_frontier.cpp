// Exhaustively check that a capped search exports each still-possible frame
// exactly once. Also check each exported small task with independent brute force.
#define main legacy_seed4_main
#include "../seed4_fifteen.cpp"
#undef main
#include "../quotient_fast.h"
#include "../quotient_prepared.h"
#include <chrono>
#include "../quotient_frontier.h"
#include <random>
struct Witness{Bits x,z;std::vector<std::pair<int,int>>pairs;};
static std::vector<Witness> brute(const std::vector<U>&X,const std::vector<U>&Z,int n,int bound){
 std::vector<Witness>out;std::vector<int>S;std::function<void(int)>rec=[&](int at){
  if((int)S.size()==n){GE g;int mono=0;Witness w;for(int i:S){g.insert(X[i]);w.x.set(i);if(__builtin_popcountll(uint64_t(X[i]>>64))==1)++mono;}if(g.n<n||mono>bound)return;
   int partners[128];std::fill(partners,partners+128,-1);
   for(int j=0;j<(int)Z.size();++j){unsigned label=0;for(int k=0;k<n;++k)label|=dot(X[S[k]],Z[j])<<k;if(label&&!(label&(label-1)))partners[__builtin_ctz(label)]=j;}
   for(int k=0;k<n;++k){if(partners[k]<0)return;w.z.set(partners[k]);w.pairs.push_back({S[k],partners[k]});}out.push_back(w);return;}
  for(int i=at;i<(int)X.size();++i){S.push_back(i);rec(i+1);S.pop_back();}
 };rec(0);return out;
}
static bool subset(const Bits&a,const Bits&b){for(int w=0;w<Bits::NW;++w)if(a.w[w]&~b.w[w])return false;return true;}
int main(){std::mt19937 gen(20261027);int controls=0,witnesses=0,tasks=0;
 for(int trial=0;trial<5000;++trial){int n=2+gen()%4,bound=gen()%(n+1);std::vector<U>X,Z;for(int v=1;v<(1<<n);++v){if(gen()%3==0)X.push_back(U(v)<<64);if(gen()%3==0)Z.push_back(U(v)<<64);}if(rank_of(X)!=n||rank_of(Z)!=n)continue;
  auto all=brute(X,Z,n,bound);FrontierQuotient q(X,Z);q.max_seed4=bound;Bits a,b;a.fill(X.size());b.fill(Z.size());uint64_t nodes=0;bool capped=false;std::vector<std::pair<int,int>>sol;bool found=q.complete(a,b,n,2,nodes,capped,&sol);++controls;
  if(found){if(all.empty())return 1;continue;}
  if(!capped&&!all.empty())return 2;
  for(auto&w:all){int count=0;
   for(auto&t:q.frontier){Bits remainX=w.x,remainZ=w.z;bool ok=true;
    for(auto[i,j]:t.fixed){if(std::find(w.pairs.begin(),w.pairs.end(),std::pair<int,int>{i,j})==w.pairs.end())ok=false;remainX.reset(i);remainZ.reset(j);}
    if(ok&&subset(remainX,t.a)&&subset(remainZ,t.b))++count;
   }if(count!=1){std::cerr<<"coverage count "<<count<<" trial "<<trial<<"\n";return 3;}++witnesses;
  }
  for(auto&t:q.frontier){std::vector<U>xx,zz;int remaining=n-t.fixed.size(),mono=0;for(auto[i,j]:t.fixed)if(__builtin_popcountll(uint64_t(X[i]>>64))==1)++mono;t.a.each([&](int i){xx.push_back(X[i]);});t.b.each([&](int j){zz.push_back(Z[j]);});auto completions=brute(xx,zz,remaining,bound-mono);if(all.empty()&&!completions.empty())return 4;++tasks;}
 }
 std::cout<<"PASS frontier: "<<controls<<" exhaustive controls; "<<witnesses<<" valid frames covered exactly once; "<<tasks<<" tasks checked\n";return controls&&witnesses&&tasks?0:5;
}
