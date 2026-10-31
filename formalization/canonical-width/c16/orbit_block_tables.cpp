// Exact cardinality tables for a circulant bipartite block of order P<=16.
// Given X subset I, allowed Z vertices have degree0 or1. Degree1 vertices
// partition by their unique X owner. Choosing n distinct owners and any
// z0 degree0 vertices gives exactly (|I|,n+z0,n), with max degree1 on both sides.
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>
int main(int argc,char**argv){
 if(argc<3)return 1;int P=argc>3?std::stoi(argv[3]):16;if(P<1||P>16)return 1;
 std::ifstream in(argv[1]);std::ofstream out(argv[2]);out<<"[";unsigned f;bool comma=false;
 while(in>>f){if(f>=(1u<<P))return 1;unsigned columns[16]{};for(int j=0;j<P;++j)for(int i=0;i<P;++i)if(f>>((j-i+P)%P)&1)columns[j]|=1u<<i;
  bool states[17][17][17]{},allowed[17][17][17]{};
  for(unsigned I=0;I<(1u<<P);++I){int x=__builtin_popcount(I),zero=0;unsigned owners=0;
   for(int j=0;j<P;++j){unsigned hit=I&columns[j];if(!hit)++zero;else if(!(hit&(hit-1)))owners|=hit;}
   states[x][__builtin_popcount(owners)][zero]=true;
  }
  for(int x=0;x<=P;++x)for(int u=0;u<=P;++u)for(int zero=0;zero<=P;++zero)if(states[x][u][zero])for(int n=0;n<=u;++n)for(int z0=0;z0<=zero;++z0)allowed[x][n+z0][n]=true;
  if(comma)out<<",";comma=true;out<<"{\"pattern\":"<<f<<",\"P\":"<<P<<",\"states\":[";bool c=false;
  for(int x=0;x<=P;++x)for(int u=0;u<=P;++u)for(int z0=0;z0<=P;++z0)if(states[x][u][z0]){if(c)out<<",";c=true;out<<"["<<x<<","<<u<<","<<z0<<"]";}
  out<<"],\"allowed\":[";c=false;
  for(int x=0;x<=P;++x)for(int z=0;z<=P;++z)for(int n=0;n<=P;++n)if(allowed[x][z][n]){if(c)out<<",";c=true;out<<"["<<x<<","<<z<<","<<n<<"]";}
  out<<"]}";
 }
 out<<"]\n";
}
