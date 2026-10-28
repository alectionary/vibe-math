// Exact F2 Gaussian elimination on source rank-one atoms, not frame search.
// For every full dual frame sum x_i z_i^T = I. A linear functional L with
// L(I)=1 forces some selected atom in its support. Start outside a proved
// cover and greedily adjoin whole symmetry classes while I stays outside span.
#include <array>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

using Vec=std::array<uint64_t,256>;
using U128=__uint128_t;
using Key=std::tuple<int,int,int>;
struct Elim {
  std::vector<Vec> basis;
  std::array<bool,16384> used{};
  int rank=0;
  Elim():basis(16384){}
  int insert(Vec v) {
    for(int w=255;w>=0;--w) while(v[w]) {
      int b=63-__builtin_clzll(v[w]),p=64*w+b;
      if(!used[p]) {basis[p]=v;used[p]=true;++rank;return p;}
      const auto &q=basis[p];
      for(int k=0;k<=w;++k) v[k]^=q[k];
    }
    return -1;
  }
  Vec reduce(Vec v) const {
    for(int w=255;w>=0;--w) while(v[w]) {
      int b=63-__builtin_clzll(v[w]),p=64*w+b;
      if(!used[p]) {
        // Continue eliminating other pivot coordinates, retaining this free bit.
        for(int q=p-1;q>=0;--q) if(used[q] && ((v[q/64]>>(q%64))&1))
          for(int k=0;k<=q/64;++k) v[k]^=basis[q][k];
        return v;
      }
      for(int k=0;k<=w;++k) v[k]^=basis[p][k];
    }
    return v;
  }
};
U128 parse(const std::string &s) {
  U128 v=0;
  for(char c:s) {if(c=='x') {v=0;continue;}int d=(c>='0'&&c<='9')?c-'0':(c>='a'&&c<='f')?c-'a'+10:-1;if(d>=0) v=(v<<4)|d;}
  return v;
}
std::vector<U128> load(const char *path) {std::ifstream f(path);if(!f)throw std::runtime_error("open coordinates");std::vector<U128> v;std::string s;while(f>>s)v.push_back(parse(s));return v;}
Vec atom(U128 x,U128 z) {
  Vec a{};
  for(int i=0;i<128;++i) if((x>>i)&1) {a[2*i]=(uint64_t)z;a[2*i+1]=(uint64_t)(z>>64);}
  return a;
}
int parity(U128 x) {return (__builtin_popcountll((uint64_t)x)+__builtin_popcountll((uint64_t)(x>>64)))&1;}
Key canon(int a,int b,int h) {return std::min(Key(a,b,h),Key(b,a,(16-h)%16));}
bool zero(const Vec &v) {for(auto w:v)if(w)return false;return true;}
std::string hex128(U128 v) {if(!v)return "0";std::string s;while(v){s="0123456789abcdef"[(int)(v&15)]+s;v>>=4;}return s;}
int main(int argc,char **argv) {
  if(argc!=5){std::cerr<<"Xcoords Zcoords cover-tuples output-json\n";return 2;}
  auto start=std::chrono::steady_clock::now();
  auto X=load(argv[1]),Z=load(argv[2]);
  if(X.size()!=720||Z.size()!=720)return 3;
  std::set<Key> cover;
  std::ifstream cf(argv[3]);int a,b,h;while(cf>>a>>b>>h)cover.insert(Key(a,b,h));
  if(cover.size()!=518)return 4;
  std::map<Key,std::vector<std::pair<int,int>>> remaining;
  Elim E;
  Vec target{};for(int i=0;i<128;++i)target[(129*i)/64]|=uint64_t(1)<<(129*i%64);
  long long outside=0;
  std::vector<std::pair<int,int>> rank_witness;
  for(int i=0;i<720;++i) {
    for(int j=0;j<720;++j)if(parity(X[i]&Z[j])) {
      Key key=canon(i/16,j/16,(j-i+720)%16);
      if(cover.count(key))remaining[key].push_back({i,j});
      else {int p=E.insert(atom(X[i],Z[j]));if(p>=0)rank_witness.push_back({i,j});++outside;}
    }
    if(i%160==0)std::cout<<"source row "<<i<<", outside rank "<<E.rank<<std::endl;
    if(std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count()>120){std::cerr<<"wall bound\n";return 124;}
  }
  auto residual=E.reduce(target);
  if(zero(residual)){std::cerr<<"FAIL: target already in outside span\n";return 5;}
  int initial_rank=E.rank,removed=0;
  for(const auto &entry:remaining) {
    std::vector<int> inserted;
    for(auto pair:entry.second){int p=E.insert(atom(X[pair.first],Z[pair.second]));if(p>=0)inserted.push_back(p);}
    if(zero(E.reduce(target))) {
      for(int p:inserted){E.used[p]=false;--E.rank;}
    } else {cover.erase(entry.first);++removed;}
  }
  residual=E.reduce(target);
  Vec L{};int free=-1;
  for(int i=0;i<16384;++i)if((residual[i/64]>>(i%64))&1){free=i;break;}
  if(free<0)return 6;
  L[free/64]|=uint64_t(1)<<(free%64);
  for(int p=0;p<16384;++p)if(E.used[p]){
    int v=0;for(int k=0;k<=p/64;++k)v^=__builtin_parityll(E.basis[p][k]&L[k]);
    if(v)L[p/64]^=uint64_t(1)<<(p%64);
  }
  int trace=0;for(int i=0;i<128;++i)trace^=(L[(129*i)/64]>>(129*i%64))&1;
  if(trace!=1)return 7;
  std::ofstream out(argv[4]);
  out<<"{\n  \"status\": \"PASS\",\n  \"source_C16_answered\": false,\n  \"outside_atom_count\": "<<outside<<",\n  \"outside_span_rank\": "<<initial_rank<<",\n  \"greedy_removed_classes\": "<<removed<<",\n  \"retained_case_count\": "<<cover.size()<<",\n  \"trace\": 1,\n  \"functional_rows_hex\": [\n";
  for(int i=0;i<128;++i)out<<"    \""<<hex128((U128)L[2*i]|((U128)L[2*i+1]<<64))<<"\""<<(i==127?"\n":",\n");
  out<<"  ],\n  \"outside_rank_witness_pairs\": [\n";
  for(size_t i=0;i<rank_witness.size();++i)out<<"    ["<<rank_witness[i].first<<", "<<rank_witness[i].second<<"]"<<(i+1==rank_witness.size()?"\n":",\n");
  out<<"  ],\n  \"retained_case_tuples\": [\n";
  int c=0;for(auto key:cover){auto [x,z,d]=key;out<<"    ["<<x<<", "<<z<<", "<<d<<"]"<<(++c==(int)cover.size()?"\n":",\n");}
  out<<"  ],\n  \"elapsed_seconds\": "<<std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count()<<"\n}\n";
  std::cout<<"PASS: outside rank "<<initial_rank<<", removed "<<removed<<", retained "<<cover.size()<<std::endl;
}
