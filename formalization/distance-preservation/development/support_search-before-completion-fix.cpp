// Syndrome-guided bounded search. Exact input arithmetic; budget exhaustion is not exclusion.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <unordered_map>
#include <vector>
using S=std::array<uint64_t,5>;
using V=std::array<uint64_t,10>;
struct Hash {size_t operator()(const S& s)const{size_t h=0;for(auto x:s)h^=x+0x9e3779b97f4a7c15ULL+(h<<6)+(h>>2);return h;}};
S plusS(S a,const S& b){for(int i=0;i<5;i++)a[i]^=b[i];return a;}
int pop(const S& a){int s=0;for(auto x:a)s+=__builtin_popcountll(x);return s;}
int pivot(const V& v){for(int i=9;i>=0;i--)if(v[i])return 64*i+63-__builtin_clzll(v[i]);return -1;}
int n,m,L,bound,maxdegree;uint64_t limit,nodes=0;bool exhausted=false;
std::vector<S> cols;std::vector<std::vector<int>> neighbors;
std::vector<V> basis;std::vector<bool> has,forbidden;std::vector<int> support,found;
std::unordered_map<S,std::vector<std::array<int,2>>,Hash> pairs;
std::unordered_map<S,std::vector<int>,Hash> singles;
bool nonstab(){V v{};for(int j:support)v[j/64]^=1ULL<<(j%64);while(true){int p=pivot(v);if(p<0)return false;if(!has[p])return true;for(int i=0;i<10;i++)v[i]^=basis[p][i];}}
bool dfs(S syn){
 if(++nodes>limit){exhausted=true;return false;}
 int rem=bound-int(support.size()),np=pop(syn);
 if(!np){if(nonstab()){found=support;return true;}return false;}
 if(rem<=0||np>maxdegree*rem)return false;
 if(rem==1){auto it=singles.find(syn);if(it!=singles.end())for(int a:it->second)if(!forbidden[a]){support.push_back(a);if(nonstab()){found=support;return true;}support.pop_back();}return false;}
 if(rem==2){auto it=pairs.find(syn);if(it!=pairs.end())for(auto ab:it->second)if(!forbidden[ab[0]]&&!forbidden[ab[1]]){support.push_back(ab[0]);support.push_back(ab[1]);if(nonstab()){found=support;return true;}support.pop_back();support.pop_back();}return false;}
 int best=-1,least=n+1;
 for(int c=0;c<m;c++)if((syn[c/64]>>(c%64))&1){int avail=0;for(int v:neighbors[c])avail+=!forbidden[v];if(avail<least){least=avail;best=c;}}
 if(least==0)return false;
 std::vector<int> excluded;
 for(int v:neighbors[best])if(!forbidden[v]){
  forbidden[v]=true;excluded.push_back(v);support.push_back(v);
  if(dfs(plusS(syn,cols[v])))return true;
  support.pop_back();if(exhausted)break;
 }
 for(int v:excluded)forbidden[v]=false;
 return false;
}
int main(){
 int nr;std::cin>>n>>m>>nr>>L>>bound>>limit;
 if(n>640||m>320||n%L){std::cerr<<"invalid dimensions\n";return 2;}
 cols.resize(n);neighbors.resize(m);basis.resize(n);has.assign(n,false);
 maxdegree=0;
 for(int v=0;v<n;v++){
  for(auto& x:cols[v])std::cin>>x;singles[cols[v]].push_back(v);maxdegree=std::max(maxdegree,pop(cols[v]));
  for(int c=0;c<m;c++)if((cols[v][c/64]>>(c%64))&1)neighbors[c].push_back(v);
 }
 for(int k=0;k<nr;k++){
  V v{};for(auto& x:v)std::cin>>x;
  while(true){int p=pivot(v);if(p<0)break;if(!has[p]){basis[p]=v;has[p]=true;break;}for(int i=0;i<10;i++)v[i]^=basis[p][i];}
 }
 for(int a=0;a<n;a++)for(int b=a+1;b<n;b++)pairs[plusS(cols[a],cols[b])].push_back({a,b});
 for(int a=0;a<n;a+=L){
  forbidden.assign(n,false);for(int v=0;v<=a;v++)forbidden[v]=true;support={a};
  if(dfs(cols[a])||exhausted)break;
 }
 std::sort(found.begin(),found.end());
 std::cout<<"{\"nodes\":"<<nodes<<",\"budget_exhausted\":"<<(exhausted?"true":"false")<<",\"witness\":[";
 for(size_t i=0;i<found.size();i++){if(i)std::cout<<',';std::cout<<found[i];}std::cout<<"]}\n";
}
