// Exact symbol-weight comparisons for structured trace-one matrix witnesses.
// A symbol is the32-bit evaluation on both orientations of a cyclic pair class.
// Matrices are auxiliary linear functionals; the source frame dictionaries do
// not change. No global minimum over all128x128 matrices is claimed.
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>
using U=__uint128_t;
using Mat=std::array<U,128>;
using Key=std::tuple<int,int,int>;
U parse(std::string s){U v=0;for(char c:s){if(c=='x'){v=0;continue;}int d=c>='0'&&c<='9'?c-'0':c>='a'&&c<='f'?c-'a'+10:-1;if(d>=0)v=(v<<4)|d;}return v;}
std::vector<U> load(const char*p){std::ifstream f(p);std::vector<U> v;std::string s;while(f>>s)v.push_back(parse(s));return v;}
int parity(U v){return (__builtin_popcountll((uint64_t)v)+__builtin_popcountll((uint64_t)(v>>64)))&1;}
uint16_t rr(uint16_t v,int h){h=(h+16)%16;return (uint16_t)((v>>h)|(uint32_t(v)<<(16-h)));}
std::string hex(U v){if(!v)return "0";std::string s;while(v){s="0123456789abcdef"[(int)(v&15)]+s;v>>=4;}return s;}
Mat outer(U v,U u){Mat M{};for(int i=0;i<128;++i)if((v>>i)&1)M[i]=u;return M;}
int main(int argc,char**argv){
 if(argc!=6){std::cerr<<"X Z class-tuples source-witness-indices output\n";return 2;}
 auto X=load(argv[1]),Z=load(argv[2]);if(X.size()!=720||Z.size()!=720)return 3;
 std::vector<Key> E;std::ifstream ef(argv[3]);int a,b,h;while(ef>>a>>b>>h)E.push_back({a,b,h});if(E.size()!=3132)return 4;
 const int N=E.size();
 uint16_t F[45][128]{},G[45][128]{};
 for(int o=0;o<45;++o)for(int i=0;i<128;++i)for(int t=0;t<16;++t){F[o][i]|=((X[16*o+t]>>i)&1)<<t;G[o][i]|=((Z[16*o+t]>>i)&1)<<t;}
 auto code=[&](U u,U v){
  std::vector<uint32_t> out(N);uint16_t L[45]{},R[45]{};
  for(int o=0;o<45;++o)for(int t=0;t<16;++t){L[o]|=parity(X[16*o+t]&v)<<t;R[o]|=parity(u&Z[16*o+t])<<t;}
  for(int k=0;k<N;++k){auto[a,b,h]=E[k];out[k]=uint32_t(L[a]&rr(R[b],h))|(uint32_t(L[b]&rr(R[a],-h))<<16);}
  return out;
 };
 auto base=code(X[608],Z[608]);int best=0;for(auto v:base)best+=v!=0;if(best!=518)return 5;
 Mat M=outer(Z[608],X[608]);std::string description="source608";
 std::vector<uint32_t> units(16384*N);
 for(int i=0;i<128;++i)for(int j=0;j<128;++j){
  auto*p=units.data()+(128*i+j)*N;
  for(int k=0;k<N;++k){auto[a,b,h]=E[k];p[k]=uint32_t(F[a][i]&rr(G[b][j],h))|(uint32_t(F[b][i]&rr(G[a][j],-h))<<16);}
 }
 long long tested=0;
 for(int i=0;i<128;++i)for(int j=0;j<128;++j)if(i!=j){
  int n=0;auto*p=units.data()+(128*i+j)*N;for(int k=0;k<N;++k)n+=(base[k]^p[k])!=0;++tested;
  if(n<best){best=n;M=outer(Z[608],X[608]);M[i]^=U(1)<<j;description="one off-diagonal unit";}
 }
 for(int i=0;i<128;++i)for(int j=0;j<i;++j){
  auto*p=units.data()+(129*i)*N;auto*q=units.data()+(129*j)*N;int n=0;
  for(int k=0;k<N;++k)n+=(base[k]^p[k]^q[k])!=0;++tested;
  if(n<best){best=n;M=outer(Z[608],X[608]);M[i]^=U(1)<<i;M[j]^=U(1)<<j;description="two diagonal units";}
  p=units.data()+(128*i+j)*N;q=units.data()+(128*j+i)*N;n=0;
  for(int k=0;k<N;++k)n+=(base[k]^p[k]^q[k])!=0;++tested;
  if(n<best){best=n;M=outer(Z[608],X[608]);M[i]^=U(1)<<j;M[j]^=U(1)<<i;description="symmetric off-diagonal units";}
 }
 std::cout<<"Matrix-unit directions "<<tested<<", best "<<best<<std::endl;
 std::ifstream wf(argv[4]);std::vector<std::pair<int,int>> witnesses;int u,v;while(wf>>u>>v)witnesses.push_back({u,v});
 std::vector<std::vector<uint32_t>> words;for(auto[u,v]:witnesses){if(!parity(X[u]&Z[v]))return 6;words.push_back(code(X[u],Z[v]));}
 for(size_t i=0;i<words.size();++i)for(size_t j=0;j<i;++j){
  int n=0;for(int k=0;k<N;++k)n+=(base[k]^words[i][k]^words[j][k])!=0;++tested;
  if(n<best){best=n;M=outer(Z[608],X[608]);auto A=outer(Z[witnesses[i].second],X[witnesses[i].first]),B=outer(Z[witnesses[j].second],X[witnesses[j].first]);for(int r=0;r<128;++r)M[r]^=A[r]^B[r];description="odd sum of three source-pair functionals";std::cout<<"improved to "<<best<<std::endl;}
 }
 int trace=0;for(int i=0;i<128;++i)trace^=(M[i]>>i)&1;if(trace!=1)return 7;
 std::ofstream out(argv[5]);out<<"{\n  \"status\":\"PASS\",\n  \"source_C16_answered\":false,\n  \"tested_trace_one_matrices\":"<<tested<<",\n  \"source_pair_functionals\":"<<words.size()<<",\n  \"best_case_count\":"<<best<<",\n  \"best_construction\":\""<<description<<"\",\n  \"trace\":1,\n  \"matrix_rows_hex\":[\n";
 for(int i=0;i<128;++i)out<<"    \""<<hex(M[i])<<"\""<<(i==127?"\n":",\n");out<<"  ],\n  \"scope\":\"All single off-diagonal, paired diagonal, and symmetric off-diagonal unit perturbations of the old witness; plus every pair among the supplied source functionals added to the old witness. No unrestricted optimum claim.\"\n}\n";
 std::cout<<"PASS: "<<tested<<" structured matrices, best "<<best<<std::endl;
}
