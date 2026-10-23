// Independent census: anchor at fiber zero of the smallest occupied block.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <set>
#include <unordered_map>
#include <vector>
struct Key{uint64_t lo,hi;bool operator==(const Key& b)const{return lo==b.lo&&hi==b.hi;}};
struct Hash{size_t operator()(const Key& k)const{return k.lo^(k.hi+0x9e3779b97f4a7c15ULL+(k.lo<<6)+(k.lo>>2));}};
int main(){int n;std::cin>>n;std::vector<Key> c(n);for(auto& k:c)std::cin>>k.lo>>k.hi;std::set<std::array<int,6>> supports;
 for(int anchor=0;anchor<n;anchor+=14){std::unordered_map<Key,std::array<int,2>,Hash> pairs;
  for(int a=anchor+1;a<n;++a)for(int b=a+1;b<n;++b)if(!pairs.emplace(Key{c[a].lo^c[b].lo,c[a].hi^c[b].hi},std::array<int,2>{a,b}).second)return 2;
  for(int a=anchor+1;a<n;++a)for(int b=a+1;b<n;++b)for(int d=b+1;d<n;++d){auto it=pairs.find(Key{c[anchor].lo^c[a].lo^c[b].lo^c[d].lo,c[anchor].hi^c[a].hi^c[b].hi^c[d].hi});if(it==pairs.end())continue;
   std::array<int,6> word{anchor,a,b,d,it->second[0],it->second[1]};std::sort(word.begin(),word.end());if(std::adjacent_find(word.begin(),word.end())!=word.end())return 3;
   for(int shift=0;shift<14;++shift){std::array<int,6> rotated;for(int i=0;i<6;++i)rotated[i]=14*(word[i]/14)+(word[i]%14+shift)%14;std::sort(rotated.begin(),rotated.end());supports.insert(rotated);}
  }
 }
 std::cout<<'[';bool first=true;for(const auto& word:supports){if(!first)std::cout<<',';first=false;std::cout<<'[';for(int i=0;i<6;++i){if(i)std::cout<<',';std::cout<<word[i];}std::cout<<']';}std::cout<<"]\n";
}
