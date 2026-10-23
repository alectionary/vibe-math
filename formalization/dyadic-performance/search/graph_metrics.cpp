// Exact simple-cycle and size<=4 absorbing spectra for binary Tanner graphs.
// Input: n m, then m rows (degree, variable indices). Checks <=64.
#include <algorithm>
#include <array>
#include <cstdint>
#include <functional>
#include <iostream>
#include <map>
#include <tuple>
#include <vector>

int main() {
  int n,m;
  if (!(std::cin>>n>>m) || n<1 || m<1 || m>64) return 1;
  std::vector<std::vector<int>> adj(n+m), vn(n);
  std::vector<uint64_t> columns(n,0);
  for(int c=0;c<m;++c) {
    int degree; std::cin>>degree;
    for(int k=0;k<degree;++k) {
      int v;std::cin>>v;if(v<0 || v>=n || (columns[v]&(uint64_t(1)<<c)))return 2;
      adj[n+c].push_back(v);adj[v].push_back(n+c);vn[v].push_back(c);
      columns[v]|=uint64_t(1)<<c;
    }
  }
  std::array<long long,9> cycles{};
  std::vector<bool> seen(n+m,false);
  std::vector<int> path;
  for(int root=0;root<n;++root) {
    seen[root]=true;path={root};
    std::function<void(int)> dfs=[&](int u) {
      for(int v:adj[u]) {
        if(v==root) {
          if(path.size()>=4 && path[1]<path.back())++cycles[path.size()];
        } else if(v>root && !seen[v] && path.size()<8) {
          seen[v]=true;path.push_back(v);dfs(v);path.pop_back();seen[v]=false;
        }
      }
    };
    dfs(root);seen[root]=false;
  }
  using Key=std::tuple<int,int,bool,bool>;
  std::map<Key,long long> counts;
  std::vector<int> support;
  auto inspect=[&](uint64_t odd) {
    for(int v:support)
      if(2*__builtin_popcountll(columns[v]&odd)>=int(vn[v].size()))return;
    std::array<int,64> degree{};
    for(int v:support)for(int c:vn[v])++degree[c];
    bool elementary=*std::max_element(degree.begin(),degree.begin()+m)<=2;
    int reached=1;
    for(int pass=0;pass<int(support.size());++pass)
      for(int i=0;i<int(support.size());++i)if(reached&(1<<i))
        for(int j=0;j<int(support.size());++j)
          if(columns[support[i]]&columns[support[j]])reached|=1<<j;
    bool connected=reached==((1<<support.size())-1);
    ++counts[{int(support.size()),__builtin_popcountll(odd),elementary,connected}];
  };
  std::function<void(int,int,uint64_t)> enumerate=[&](int start,int remaining,uint64_t odd) {
    if(!remaining){inspect(odd);return;}
    for(int v=start;v<=n-remaining;++v){
      support.push_back(v);enumerate(v+1,remaining-1,odd^columns[v]);support.pop_back();
    }
  };
  for(int a=2;a<=4;++a)enumerate(0,a,0);
  std::cout<<cycles[4]<<' '<<cycles[6]<<' '<<cycles[8]<<'\n';
  for(auto [key,count]:counts){
    auto [a,b,e,c]=key;
    std::cout<<a<<' '<<b<<' '<<e<<' '<<c<<' '<<count<<'\n';
  }
  return std::cin.fail()?3:0;
}
