// Discovery only: exact finite-field constraints for the frozen 6U+4V pattern.
#include <array>
#include <vector>
#include <map>
#include <string>
#include <iostream>
#include <algorithm>
using F=std::array<int,6>;
int mod(int a,int p){a%=p;return a<0?a+p:a;}
F entry(int i,int j){F x{};if(i&&j)x[(i-1)*3+j-1]=1;return x;}
F add(F a,F b,int sign=1){for(int k=0;k<6;k++)a[k]+=sign*b[k];return a;}
int eval(F a,F e,int p){int v=0;for(int k=0;k<6;k++)v+=a[k]*e[k];return mod(v,p);}
bool eligible(F e,int p){
 int E[3][4]{};for(int i=1;i<3;i++)for(int j=1;j<4;j++)E[i][j]=e[(i-1)*3+j-1];
 for(int i=0;i<3;i++)for(int k=i+1;k<3;k++)for(int a=0;a<4;a++)for(int b=a+1;b<4;b++)
  if(!mod(E[i][a]-E[k][a]+E[k][b]-E[i][b],p))return false;
 for(int a=0;a<4;a++)for(int b=0;b<4;b++)if(a!=b)for(int c=0;c<4;c++)if(c!=a&&c!=b)
  if(!mod(E[0][a]-E[1][a]+E[1][b]-E[2][b]+E[2][c]-E[0][c],p))return false;
 for(int k=0;k<3;k++){
  int i=(k+1)%3,j=(k+2)%3;std::map<int,int> counts;
  for(int c=0;c<4;c++)if(++counts[mod(E[i][c]+E[j][c]-2*E[k][c],p)]>=3)return false;
 }
 for(int b=1;b<4;b++){
  std::vector<int> other;for(int j=1;j<4;j++)if(j!=b)other.push_back(j);
  bool same=true;for(int i=0;i<3;i++)same&=!mod(E[i][0]+E[i][b]-E[i][other[0]]-E[i][other[1]],p);
  if(same)return false;
 }
 return true;
}
int main(int argc,char**argv){
 int p=argc>1?std::stoi(argv[1]):13;
 std::vector<std::array<int,2>> cp,rp;
 for(int a=0;a<4;a++)for(int b=a+1;b<4;b++)cp.push_back({a,b});
 for(int a=0;a<3;a++)for(int b=a+1;b<3;b++)rp.push_back({a,b});
 long patterns=0,spaces=0,tested=0,positive=0;std::map<std::string,std::vector<F>> cache;std::map<int,int> ranks;
 for(int c0=0;c0<6;c0++)for(int c1=0;c1<6;c1++)for(int c2=0;c2<6;c2++)
 for(int r0=0;r0<3;r0++)for(int r1=0;r1<3;r1++)for(int bits=0;bits<64;bits++){
  patterns++;std::array<int,3> cs={c0,c1,c2};std::array<int,2> rs={r0,r1};
  std::array<F,8>A{};F z[2][3];int row=0;
  for(int i=0;i<2;i++)for(int j=0;j<3;j++){
   int flip=(bits>>(i*3+j))&1;auto c=cp[cs[j]],r=rp[rs[i]];
   z[i][j]=add(entry(i+1,c[0]),entry(r[flip],j+1));
   A[row++]=add(z[i][j],add(entry(i+1,c[1]),entry(r[1-flip],j+1)),-1);
  }
  for(int j=1;j<3;j++)A[row++]=add(add(z[1][j],z[0][j],-1),add(z[1][0],z[0][0],-1),-1);
  std::vector<int> piv;int rank=0;
  for(int c=0;c<6;c++){
   int k=rank;while(k<8&&!mod(A[k][c],p))k++;if(k==8)continue;
   std::swap(A[k],A[rank]);int inv=1;while(mod(A[rank][c]*inv,p)!=1)inv++;
   for(auto&v:A[rank])v=mod(v*inv,p);
   for(int i=0;i<8;i++)if(i!=rank){int f=mod(A[i][c],p);for(int j=0;j<6;j++)A[i][j]=mod(A[i][j]-f*A[rank][j],p);}
   piv.push_back(c);rank++;
  }
  ranks[rank]++;std::string key;for(int i=0;i<rank;i++)for(int v:A[i])key.push_back(char(v));key.push_back(char(rank));
  if(!cache.count(key)){
   spaces++;std::vector<int> free;for(int c=0;c<6;c++)if(std::find(piv.begin(),piv.end(),c)==piv.end())free.push_back(c);
   long count=1;for(int c:free)count=std::min(2001L,count*p);if(free.size()==1)count=2;count=std::min(count,2001L);
   std::vector<F> valid;
   for(long t=1;t<count;t++){
    long q=t;F e{};for(int c:free){e[c]=q%p;q/=p;}
    for(int i=0;i<rank;i++){int v=0;for(int c:free)v+=A[i][c]*e[c];e[piv[i]]=mod(-v,p);}
    tested++;if(eligible(e,p)&&valid.size()<8)valid.push_back(e);
   }
   cache[key]=valid;
  }
  for(F e:cache[key]){
   int x[3],y[2]={0,eval(add(z[1][0],z[0][0],-1),e,p)};
   for(int j=0;j<3;j++)x[j]=mod(-eval(z[0][j],e,p),p);
   std::cout<<"{\"L\":"<<p<<",\"exponents\":[";
   for(int k=0;k<6;k++){if(k)std::cout<<',';std::cout<<e[k];}
   std::cout<<"],\"column_pairs\":[";for(int j=0;j<3;j++){if(j)std::cout<<',';std::cout<<'['<<cp[cs[j]][0]<<','<<cp[cs[j]][1]<<']';}
   std::cout<<"],\"row_pairs\":[";for(int i=0;i<2;i++){if(i)std::cout<<',';std::cout<<'['<<rp[rs[i]][0]<<','<<rp[rs[i]][1]<<']';}
   std::cout<<"],\"bits\":"<<bits<<",\"support\":[";bool first=true;
   for(int j=0;j<3;j++)for(int c:cp[cs[j]]){if(!first)std::cout<<',';first=false;std::cout<<((j+1)*4+c)*p+x[j];}
   for(int i=0;i<2;i++)for(int r:rp[rs[i]])std::cout<<','<<(16+r*3+i+1)*p+y[i];
   std::cout<<"]}"<<std::endl;positive++;
  }
 }
 std::cerr<<"{\"L\":"<<p<<",\"patterns\":"<<patterns<<",\"spaces\":"<<spaces<<",\"tested_assignments\":"<<tested<<",\"positive_patterns\":"<<positive<<",\"ranks\":{";
 bool first=true;for(auto [r,c]:ranks){if(!first)std::cerr<<',';first=false;std::cerr<<'"'<<r<<"\":"<<c;}std::cerr<<"}}\n";
}
