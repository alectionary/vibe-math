#include <array>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
using U=__uint128_t;
U parse(std::string s){U x=0;for(char c:s){int n=c>='0'&&c<='9'?c-'0':c>='a'&&c<='f'?c-'a'+10:0;x=(x<<4)|n;}return x;}
struct Basis{std::array<U,128>p{};int rank=0;void add(U v){while(v){int b=uint64_t(v)?__builtin_ctzll(uint64_t(v)):64+__builtin_ctzll(uint64_t(v>>64));if(!p[b]){p[b]=v;++rank;return;}v^=p[b];}}};
int main(int argc,char**argv){std::ifstream in(argv[1]);int thin,thick;in>>thin>>thick;int period=argc>3?std::stoi(argv[3]):16,dimension=argc>4?std::stoi(argv[4]):128;std::vector<std::vector<U>>O(thin*thick);for(auto&o:O)for(int h=0;h<period;++h){std::string s;in>>s;o.push_back(parse(s));}std::ofstream out(argv[2]);out<<"[";bool comma=false;int total=0;
 for(int T=1;T<(1<<thin);++T){std::vector<Basis>byI(1<<thick);for(int I=1;I<(1<<thick);++I){int j=__builtin_ctz(I);auto &b=byI[I];b=byI[I^(1<<j)];for(int c=0;c<thin;++c)if(T>>c&1)for(U v:O[c*thick+j])b.add(v);int count=__builtin_popcount(T)*__builtin_popcount(I);if(b.rank>=dimension||b.rank==period*count)continue;if(comma)out<<",";comma=true;out<<"{\"thin_mask\":"<<T<<",\"thick_mask\":"<<I<<",\"rank\":"<<b.rank<<"}";++total;}}
 out<<"]\n";std::cout<<total<<" nontrivial rectangles\n";
}
