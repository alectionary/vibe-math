// Anchored exact syndrome-guided logical-support search. See protocol for scope.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <unordered_map>
#include <vector>
using Word=std::array<uint64_t,4>;
struct S{uint64_t lo=0,hi=0;bool operator==(const S& b)const{return lo==b.lo&&hi==b.hi;}};
struct Hash{size_t operator()(S s)const{return s.lo^(s.hi+0x9e3779b97f4a7c15ULL+(s.lo<<6)+(s.lo>>2));}};
S add(S a,S b){return {a.lo^b.lo,a.hi^b.hi};}
int pop(S a){return __builtin_popcountll(a.lo)+__builtin_popcountll(a.hi);}
int pivot(Word w){for(int j=3;j>=0;--j)if(w[j])return j*64+63-__builtin_clzll(w[j]);return -1;}
int targetWeight; uint64_t maxNodes; bool budget=false; int n,m;std::vector<S> cols;std::vector<std::vector<int>> ns;std::map<int,Word,std::greater<int>> basis;std::unordered_map<S,std::array<int,2>,Hash> pairs;std::unordered_map<S,int,Hash> singles;
std::vector<int> support,found;std::vector<bool> forbidden;uint64_t nodes=0;
bool nonstab(){Word w{};for(int v:support)w[v/64]|=1ULL<<(v%64);while(pivot(w)>=0){auto it=basis.find(pivot(w));if(it==basis.end())return true;for(int j=0;j<4;++j)w[j]^=it->second[j];}return false;}
bool dfs(S syndrome){++nodes;if(nodes>maxNodes){budget=true;return false;}int rem=targetWeight-support.size();if(pop(syndrome)==0){if(nonstab()){found=support;return true;}return false;}if(rem==0||pop(syndrome)>3*rem)return false;
 if(rem==1){auto it=singles.find(syndrome);if(it!=singles.end()&&!forbidden[it->second]){int v=it->second;support.push_back(v);if(nonstab()){found=support;return true;}support.pop_back();}return false;}
 if(rem==2){auto it=pairs.find(syndrome);if(it!=pairs.end()&&!forbidden[it->second[0]]&&!forbidden[it->second[1]]){support.push_back(it->second[0]);support.push_back(it->second[1]);if(nonstab()){found=support;return true;}support.pop_back();support.pop_back();}return false;}
 int best=-1,least=100;for(int c=0;c<m;++c)if(((c<64?syndrome.lo:syndrome.hi)>>(c%64))&1){int available=0;for(int v:ns[c])available+=!forbidden[v];if(available<least){least=available;best=c;}}if(least==0)return false;
 std::vector<int> excluded;for(int v:ns[best])if(!forbidden[v]){forbidden[v]=true;excluded.push_back(v);support.push_back(v);if(dfs(add(syndrome,cols[v])))return true;support.pop_back();}for(int v:excluded)forbidden[v]=false;return false;
}
int main(){int nr;std::cin>>n>>m>>nr>>targetWeight>>maxNodes;cols.resize(n);ns.resize(m);for(int v=0;v<n;++v){std::cin>>cols[v].lo>>cols[v].hi;singles[cols[v]]=v;for(int c=0;c<m;++c)if(((c<64?cols[v].lo:cols[v].hi)>>(c%64))&1)ns[c].push_back(v);}for(int k=0;k<nr;++k){Word w;for(auto& x:w)std::cin>>x;while(pivot(w)>=0){int p=pivot(w);auto it=basis.find(p);if(it==basis.end()){basis[p]=w;break;}for(int j=0;j<4;++j)w[j]^=it->second[j];}}
 for(int a=0;a<n;++a)for(int b=a+1;b<n;++b)pairs.emplace(add(cols[a],cols[b]),std::array<int,2>{a,b});
 for(int a=0;a<n;a+=14){forbidden.assign(n,false);for(int v=0;v<=a;++v)forbidden[v]=true;support={a};if(dfs(cols[a])||budget)break;}
 std::sort(found.begin(),found.end());std::cout<<"{\"nodes\":"<<nodes<<",\"budget_exhausted\":"<<(budget?"true":"false")<<",\"search_completed_without_witness\":"<<((!budget&&found.empty())?"true":"false")<<",\"witness\":[";for(size_t i=0;i<found.size();++i){if(i)std::cout<<',';std::cout<<found[i];}std::cout<<"]}\n";
}
