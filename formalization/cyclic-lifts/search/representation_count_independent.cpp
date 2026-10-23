// Independent complete cover: a four-vertex graph without isolated vertices
// has a perfect matching or is a three-leaf star. Co-neighbor edges suffice.
// Evaluate absorbing status directly from row incidences, without syndromes.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <set>
#include <vector>
int main() {
  int n,m;if(!(std::cin>>n>>m)||n<4||m<1)return 1;
  std::vector<std::vector<uint8_t>> h(m,std::vector<uint8_t>(n,0));
  std::vector<std::vector<int>> incident(n),adj(n);
  std::vector<std::vector<bool>> neighbors(n,std::vector<bool>(n,false));
  for(int c=0;c<m;++c) {
    int d;std::cin>>d;std::vector<int> row(d);
    for(int &v:row) {std::cin>>v;if(v<0||v>=n||h[c][v])return 2;h[c][v]=1;incident[v].push_back(c);}
    for(int a:row)for(int b:row)if(a!=b)neighbors[a][b]=true;
  }
  std::vector<std::array<int,2>> edges;
  for(int a=0;a<n;++a)for(int b=0;b<n;++b)if(neighbors[a][b]) {
    adj[a].push_back(b);if(a<b)edges.push_back({a,b});
  }
  std::set<std::array<int,4>> found;
  auto test=[&](std::array<int,4> s) {
    for(int v:s) {
      int odd=0,even=0;
      for(int c:incident[v]) {
        if((h[c][s[0]]+h[c][s[1]]+h[c][s[2]]+h[c][s[3]])%2)++odd;
        else ++even;
      }
      if(even<=odd)return;
    }
    std::sort(s.begin(),s.end());found.insert(s);
  };
  for(size_t i=0;i<edges.size();++i)for(size_t j=i+1;j<edges.size();++j) {
    auto a=edges[i],b=edges[j];
    if(a[0]!=b[0]&&a[0]!=b[1]&&a[1]!=b[0]&&a[1]!=b[1])test({a[0],a[1],b[0],b[1]});
  }
  for(int v=0;v<n;++v) {
    const auto &a=adj[v];
    for(size_t i=0;i<a.size();++i)for(size_t j=i+1;j<a.size();++j)for(size_t k=j+1;k<a.size();++k)
      test({v,a[i],a[j],a[k]});
  }
  std::cout<<"[";bool first=true;
  for(const auto &s:found) {if(!first)std::cout<<",";first=false;std::cout<<"["<<s[0]<<","<<s[1]<<","<<s[2]<<","<<s[3]<<"]";}
  std::cout<<"]\n";
}
