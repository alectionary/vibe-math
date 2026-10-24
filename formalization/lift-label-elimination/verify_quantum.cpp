// Independent C++17 verifier. No Python imports; reconstructs the two matrices.
#include <array>
#include <vector>
#include <iostream>
#include <algorithm>
#include <cassert>
#include <cstdint>
using W=std::array<uint64_t,5>;
W add(W a,const W&b){for(int i=0;i<5;i++)a[i]^=b[i];return a;}
bool bit(const W&a,int i){return (a[i/64]>>(i%64))&1;}
void set(W&a,int i){a[i/64]|=uint64_t(1)<<(i%64);}
int rank(std::vector<W> a,int width){int r=0;for(int c=0;c<width;c++){int j=r;while(j<(int)a.size()&&!bit(a[j],c))j++;if(j==(int)a.size())continue;std::swap(a[r],a[j]);for(int k=r+1;k<(int)a.size();k++)if(bit(a[k],c))a[k]=add(a[k],a[r]);r++;}return r;}
int dot(const W&a,const W&b){int n=0;for(int i=0;i<5;i++)n+=__builtin_popcountll(a[i]&b[i]);return n%2;}
int main(){std::vector<W> cols[2],rows[2];long long counts[2]={};int ranks[2];
for(int h=0;h<2;h++){int n,m;std::cin>>n>>m;assert(n==280&&m==140);cols[h].resize(n);rows[h].resize(m);std::vector<int>deg(m);for(int v=0;v<n;v++){for(int k=0;k<3;k++){int c;std::cin>>c;assert(c>=0&&c<m&&!bit(cols[h][v],c));set(cols[h][v],c);set(rows[h][c],v);deg[c]++;}}
// Independent reconstruction from the incidence list, not from input masks.
int base[10][3]={{0,1,2},{0,3,4},{1,3,5},{2,4,5},{0,6,7},{1,6,8},{2,6,9},{3,7,8},{4,7,9},{5,8,9}};
auto z=[](int v,int c){return ((v==0&&c==0)||(v==4&&c==6))?7:0;};
for(int q=0;q<n;q++){W expected{};int side=q/140,u=(q%140)/14,t=q%14;if(h==0&&side==0){for(int c:base[u])set(expected,14*c+(t+z(u,c))%14);}if(h==0&&side==1){for(int e:{0,1,3})set(expected,14*u+(t-e+14)%14);}if(h==1&&side==0){for(int e:{0,1,3})set(expected,14*u+(t+e)%14);}if(h==1&&side==1){for(int v=0;v<10;v++)for(int c:base[v])if(c==u)set(expected,14*v+(t-z(v,c)+14)%14);}assert(cols[h][q]==expected);}
for(int d:deg)assert(d==6);for(int i=0;i<n;i++)for(int j=i+1;j<n;j++){int common=0;for(int q=0;q<5;q++)common+=__builtin_popcountll(cols[h][i][q]&cols[h][j][q]);assert(common<=1);}
// Enumerates every unordered four-column support, independently of pair buckets.
for(int a=0;a<n;a++)for(int b=a+1;b<n;b++){W ab=add(cols[h][a],cols[h][b]);for(int c=b+1;c<n;c++){W abc=add(ab,cols[h][c]);for(int d=c+1;d<n;d++)if(abc==cols[h][d])counts[h]++;}}
ranks[h]=rank(rows[h],n);assert(counts[h]==0&&ranks[h]==131);}
for(auto x:rows[0])for(auto z:rows[1])assert(dot(x,z)==0);
W logical{};for(int v:{28,42,70,84,98,112})set(logical,v);for(auto x:rows[0])assert(dot(x,logical)==0);auto aug=rows[1];aug.push_back(logical);int ar=rank(aug,280);assert(ar==132);
std::cout<<"{\"passed\":true,\"variables\":280,\"rank_X\":"<<ranks[0]<<",\"rank_Z\":"<<ranks[1]<<",\"logical_qubits\":18,\"N40_X\":"<<counts[0]<<",\"N40_Z\":"<<counts[1]<<",\"quadruples_per_graph\":250654530,\"augmented_Z_rank\":"<<ar<<",\"distance\":6,\"logical_support\":[28,42,70,84,98,112]}\n";
}
