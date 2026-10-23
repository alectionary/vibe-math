// Independent validation: enumerate all 8/10-cycle supports, then complete them.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <set>
#include <unordered_map>
#include <vector>
struct S{uint64_t a,b;bool operator==(const S& o)const{return a==o.a&&b==o.b;}};
struct Hash{size_t operator()(S s)const{return s.a^(s.b+0x517cc1b727220a95ULL+(s.a<<5)+(s.a>>3));}};
using Word=std::array<uint64_t,4>;
int n,m,cap;uint64_t maxNodes,nodes=0,walks=0;bool budget=false;
std::vector<S> columns;std::vector<std::vector<int>> checkVars,varChecks;
std::map<int,Word,std::greater<int>> stab;
std::unordered_map<S,std::array<int,2>,Hash> pairs;std::unordered_map<S,int,Hash> singles;
std::set<std::vector<int>> seeds;
std::vector<int> chosen,found,path;std::vector<bool> usedV,usedC,selected;
S add(S s,S t){return{s.a^t.a,s.b^t.b};}
int pop(S s){return __builtin_popcountll(s.a)+__builtin_popcountll(s.b);}
int pivot(const Word& w){for(int j=3;j>=0;--j)if(w[j])return j*64+63-__builtin_clzll(w[j]);return -1;}
bool nonstabilizer(){Word w{};for(int v:chosen)w[v/64]^=1ULL<<(v%64);while(pivot(w)>=0){auto it=stab.find(pivot(w));if(it==stab.end())return true;for(int j=0;j<4;++j)w[j]^=it->second[j];}return false;}
void cycles(int start,int current){++walks;
 if(path.size()>=4)for(int c:varChecks[current])if(!usedC[c]&&std::find(checkVars[c].begin(),checkVars[c].end(),start)!=checkVars[c].end()){auto support=path;std::sort(support.begin(),support.end());seeds.insert(support);}
 if(path.size()==5)return;
 for(int c:varChecks[current])if(!usedC[c]){usedC[c]=true;for(int v:checkVars[c])if(v>start&&!usedV[v]){usedV[v]=true;path.push_back(v);cycles(start,v);path.pop_back();usedV[v]=false;}usedC[c]=false;}
}
bool complete(S syn){if(++nodes>maxNodes){budget=true;return false;}int rem=cap-chosen.size();if(pop(syn)==0){if(nonstabilizer()){found=chosen;return true;}return false;}if(rem==0||pop(syn)>3*rem)return false;
 if(rem==1){auto it=singles.find(syn);if(it!=singles.end()&&!selected[it->second]){chosen.push_back(it->second);if(nonstabilizer()){found=chosen;return true;}chosen.pop_back();}return false;}
 if(rem==2){auto it=pairs.find(syn);if(it!=pairs.end()&&!selected[it->second[0]]&&!selected[it->second[1]]){chosen.push_back(it->second[0]);chosen.push_back(it->second[1]);if(nonstabilizer()){found=chosen;return true;}chosen.pop_back();chosen.pop_back();}return false;}
 int c=syn.a?__builtin_ctzll(syn.a):64+__builtin_ctzll(syn.b);
 for(int v:checkVars[c])if(!selected[v]){selected[v]=true;chosen.push_back(v);if(complete(add(syn,columns[v])))return true;chosen.pop_back();selected[v]=false;if(budget)return false;}return false;
}
int main(){int nr;std::cin>>n>>m>>nr>>cap>>maxNodes;columns.resize(n);checkVars.resize(m);varChecks.resize(n);selected.resize(n);usedV.resize(n);usedC.resize(m);
 for(int v=0;v<n;++v){auto& s=columns[v];std::cin>>s.a>>s.b;singles[s]=v;for(int c=0;c<m;++c)if(((c<64?s.a:s.b)>>(c%64))&1){checkVars[c].push_back(v);varChecks[v].push_back(c);}}
 for(int k=0;k<nr;++k){Word w;for(auto& b:w)std::cin>>b;while(pivot(w)>=0){int p=pivot(w);auto it=stab.find(p);if(it==stab.end()){stab[p]=w;break;}for(int j=0;j<4;++j)w[j]^=it->second[j];}}
 for(int a=0;a<n;++a)for(int b=a+1;b<n;++b)if(!pairs.emplace(add(columns[a],columns[b]),std::array<int,2>{a,b}).second)return 2;
 for(int start=0;start<n;++start){path={start};usedV[start]=true;cycles(start,start);usedV[start]=false;}
 uint64_t seed4=0,seed5=0;for(auto& s:seeds){seed4+=s.size()==4;seed5+=s.size()==5;}
 for(auto& seed:seeds){chosen=seed;std::fill(selected.begin(),selected.end(),false);S syn{0,0};for(int v:seed){selected[v]=true;syn=add(syn,columns[v]);}if(complete(syn)||budget)break;}
 std::cout<<"{\"seed4\":"<<seed4<<",\"seed5\":"<<seed5<<",\"cycle_walk_nodes\":"<<walks<<",\"completion_nodes\":"<<nodes<<",\"budget_exhausted\":"<<(budget?"true":"false")<<",\"witness\":[";for(size_t i=0;i<found.size();++i){if(i)std::cout<<',';std::cout<<found[i];}std::cout<<"]}\n";
}
