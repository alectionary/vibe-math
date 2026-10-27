// Exact bounded enumeration of short allowed-dual sums with sparse evaluation.
// This searches a Cayley ball, not full canonical frames. Every retained cut is
// justified by a short-sum witness and exact nonmembership in smaller balls.
#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
using U=unsigned __int128;
struct Hash{size_t operator()(U x)const{return uint64_t(x)^(uint64_t(x>>64)*0x9e3779b97f4a7c15ULL);}};
std::vector<U> load(const char*p){std::ifstream in(p);std::vector<U>v;std::string s;while(in>>s){U x=0;for(char c:s)x=(x<<4)|(c<='9'?c-'0':c-'a'+10);v.push_back(x);}return v;}
std::string hx(U x){std::string s(32,'0');for(int i=0;i<32;++i)s[31-i]="0123456789abcdef"[int(x>>(4*i))&15];return s;}
int dot(U x,U y){U z=x&y;return (__builtin_parityll(uint64_t(z))^__builtin_parityll(uint64_t(z>>64)));}
struct Record{U w;int k;std::array<int,3> ids;int weight;};
int main(int argc,char**argv){if(argc<6)return 1;auto X=load(argv[1]),Z=load(argv[2]);int threshold=std::stoi(argv[4]);double seconds=std::stod(argv[5]);int NW=(X.size()+63)/64;std::vector<std::vector<uint64_t>>A(Z.size(),std::vector<uint64_t>(NW));for(int j=0;j<int(Z.size());++j)for(int i=0;i<int(X.size());++i)if(dot(X[i],Z[j]))A[j][i/64]|=1ULL<<(i%64);
 std::unordered_set<U,Hash> ball1(Z.begin(),Z.end()),ball2=ball1;ball2.insert(0);for(int i=0;i<int(Z.size());++i)for(int j=i+1;j<int(Z.size());++j)ball2.insert(Z[i]^Z[j]);std::unordered_map<U,Record,Hash> keep;std::array<uint64_t,721>hist{};uint64_t done=0;bool complete=true;int minpair=10000,mintriple=10000;auto start=std::chrono::steady_clock::now();auto elapsed=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};
 for(int i=0;i<int(Z.size());++i)for(int j=i+1;j<int(Z.size());++j){U w=Z[i]^Z[j];int weight=0;for(int k=0;k<NW;++k)weight+=__builtin_popcountll(A[i][k]^A[j][k]);if(!ball1.count(w)){minpair=std::min(minpair,weight);if(weight<=threshold)keep.emplace(w,Record{w,2,{i,j,-1},weight});}}
 for(int i=0;i<int(Z.size());++i){for(int j=i+1;j<int(Z.size());++j)for(int k=j+1;k<int(Z.size());++k){++done;int weight=0;for(int b=0;b<NW;++b){weight+=__builtin_popcountll(A[i][b]^A[j][b]^A[k][b]);if(weight>threshold)break;}if(weight<=threshold){U w=Z[i]^Z[j]^Z[k];if(!ball2.count(w)){mintriple=std::min(mintriple,weight);keep.emplace(w,Record{w,3,{i,j,k},weight});}}
 if(done%1000000==0 && elapsed()>seconds){complete=false;goto ended;}}
 if(i%30==0)std::cout<<"first_index "<<i<<" triples "<<done<<" retained "<<keep.size()<<" seconds "<<elapsed()<<std::endl;}
 ended:std::vector<Record>records;for(auto&kv:keep)records.push_back(kv.second);std::sort(records.begin(),records.end(),[](auto&a,auto&b){if(a.weight!=b.weight)return a.weight<b.weight;return a.w<b.w;});std::ofstream out(argv[3]);out<<"{\"status\":\""<<(complete?"COMPLETE_SHORT_BALL":"TIME_LIMIT")<<"\",\"source_C16_answered\":false,\"threshold\":"<<threshold<<",\"triple_tuples\":"<<done<<",\"ball2_size\":"<<ball2.size()<<",\"retained_unique_words\":"<<records.size()<<",\"minimum_exact_length2_weight\":"<<minpair<<",\"minimum_retained_exact_length3_weight\":"<<mintriple<<",\"seconds\":"<<elapsed()<<",\"cuts\":[";
 bool comma=false;for(auto&r:records){if(comma)out<<",";comma=true;out<<"{\"w\":\""<<hx(r.w)<<"\",\"minimum\":"<<r.k<<",\"witness\":[";for(int k=0;k<r.k;++k)out<<(k?",":"")<<r.ids[k];out<<"],\"support\":[";bool c=false;for(int i=0;i<int(X.size());++i)if(dot(X[i],r.w)){if(c)out<<",";c=true;out<<i;}out<<"]}";}out<<"]}\n";std::cout<<"DONE "<<done<<" cuts "<<records.size()<<" minpair "<<minpair<<" mintriple "<<mintriple<<" seconds "<<elapsed()<<"\n";
}
