// Exhaustive 3+3 census of binary kernel words of weight six.
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <stdexcept>
#include <vector>
using Word=std::array<uint64_t,4>;
using Syndrome=std::array<uint64_t,2>;
Word xored(Word a,const Word& b){for(int i=0;i<4;++i)a[i]^=b[i];return a;}
int pivot(const Word& a){for(int i=3;i>=0;--i)if(a[i])return i*64+63-__builtin_clzll(a[i]);return -1;}
struct Triple{uint64_t lo,hi;uint16_t a,b,c;};
bool lessTriple(const Triple& a,const Triple& b){return a.hi!=b.hi?a.hi<b.hi:a.lo!=b.lo?a.lo<b.lo:std::array<uint16_t,3>{a.a,a.b,a.c}<std::array<uint16_t,3>{b.a,b.b,b.c};}
int main(){
 int n,m,rows;std::cin>>n>>m>>rows;if(n>256||m>128)return 1;
 std::vector<Syndrome> cols(n);for(auto& c:cols)std::cin>>c[0]>>c[1];
 std::map<int,Word,std::greater<int>> basis;
 for(int i=0;i<rows;++i){Word word;for(auto& a:word)std::cin>>a;while(pivot(word)>=0){int k=pivot(word);auto it=basis.find(k);if(it==basis.end()){basis[k]=word;break;}word=xored(word,it->second);}}
 auto member=[&](Word word){while(pivot(word)>=0){auto it=basis.find(pivot(word));if(it==basis.end())return false;word=xored(word,it->second);}return true;};
 std::vector<Syndrome> pairs;
 for(int a=0;a<n;++a){if((cols[a][0]|cols[a][1])==0)throw std::runtime_error("zero column");for(int b=a+1;b<n;++b){Syndrome s{cols[a][0]^cols[b][0],cols[a][1]^cols[b][1]};if((s[0]|s[1])==0)throw std::runtime_error("duplicate columns");pairs.push_back(s);}}
 std::sort(pairs.begin(),pairs.end());if(std::adjacent_find(pairs.begin(),pairs.end())!=pairs.end())throw std::runtime_error("kernel weight below six");
 std::vector<Triple> triples;triples.reserve(uint64_t(n)*(n-1)*(n-2)/6);
 for(int a=0;a<n;++a)for(int b=a+1;b<n;++b)for(int c=b+1;c<n;++c)triples.push_back({cols[a][0]^cols[b][0]^cols[c][0],cols[a][1]^cols[b][1]^cols[c][1],uint16_t(a),uint16_t(b),uint16_t(c)});
 std::sort(triples.begin(),triples.end(),lessTriple);
 uint64_t stabilizer=0,logical=0;std::map<std::array<int,6>,bool> supports;
 for(size_t start=0;start<triples.size();){size_t end=start+1;while(end<triples.size()&&triples[end].lo==triples[start].lo&&triples[end].hi==triples[start].hi)++end;
  for(size_t i=start;i<end;++i)for(size_t j=i+1;j<end;++j){const auto& a=triples[i];const auto& b=triples[j];std::array<int,6> support{a.a,a.b,a.c,b.a,b.b,b.c};std::sort(support.begin(),support.end());if(std::adjacent_find(support.begin(),support.end())!=support.end())throw std::runtime_error("overlapping triples");Word word{};for(int v:support)word[v/64]^=1ULL<<(v%64);bool islogical=!member(word);if(islogical)++logical;else ++stabilizer;auto entry=supports.emplace(support,islogical);if(!entry.second&&entry.first->second!=islogical)return 2;}
  start=end;
 }
 if(logical%10||stabilizer%10||supports.size()!=(logical+stabilizer)/10)return 3;
 std::cout<<"{\"rank_stabilizer\":"<<basis.size()<<",\"pair_syndromes\":"<<pairs.size()<<",\"triples\":"<<triples.size()<<",\"logical_weight6\":"<<logical/10<<",\"stabilizer_weight6\":"<<stabilizer/10<<",\"supports\":[";
 bool first=true;for(auto& item:supports){if(!first)std::cout<<',';first=false;std::cout<<"{\"logical\":"<<(item.second?"true":"false")<<",\"support\":[";for(int i=0;i<6;++i){if(i)std::cout<<',';std::cout<<item.first[i];}std::cout<<"]}";}
 std::cout<<"]}\n";
}
