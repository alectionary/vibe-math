// Mixed-sign full-basis clauses from conditional orthogonal-complement spans.
// Certificates, not native solver conclusions, are checked in Python.
#include <algorithm>
#include <array>
#include <cstdint>
#include <stdexcept>
#include <vector>
using U=unsigned __int128;
static int parity(U v){return (__builtin_popcountll(uint64_t(v))+__builtin_popcountll(uint64_t(v>>64)))&1;}
static int high(U v){return (v>>64)?127-__builtin_clzll(uint64_t(v>>64)):63-__builtin_clzll(uint64_t(v));}
struct SpanCertificate {uint64_t lo,hi;int kind,side,count,omitted;int ids[129];};
struct Basis {
 std::array<U,128> r{},tags{};std::vector<int> original;U used=0,twice=0;
 bool add(U v,int id,std::vector<int>*circuit=nullptr){
  U comb=0;
  while(v){int p=high(v);if(!r[p]){int k=original.size();r[p]=v;tags[p]=comb^(U(1)<<k);original.push_back(id);return true;}v^=r[p];comb^=tags[p];}
  twice|=used&comb;used|=comb;
  if(circuit){for(int k=0;k<int(original.size());++k)if((comb>>k)&1)circuit->push_back(original[k]);circuit->push_back(id);}
  return false;
 }
 U reduce(U v)const{while(v){int p=high(v);if(!r[p])break;v^=r[p];}return v;}
 U annihilator(int free,int N)const{U w=U(1)<<free;for(int p=0;p<N;++p)if(r[p]&&parity(r[p]&w))w^=U(1)<<p;return w;}
 U dual(int k,int N)const{U w=0;for(int p=0;p<N;++p)if(r[p]&&(parity(r[p]&w)!=int((tags[p]>>k)&1)))w^=U(1)<<p;return w;}
};
struct ConditionalSpanContext {
 int N;std::array<std::vector<U>,2> V;std::array<std::vector<uint8_t>,2> adjacency;
 ConditionalSpanContext(std::vector<U>x,std::vector<U>z,int n):N(n),V{std::move(x),std::move(z)}{
  if(n<1||n>128)throw std::runtime_error("invalid binary dimension");
  adjacency[0].resize(V[0].size()*V[1].size());adjacency[1].resize(V[0].size()*V[1].size());
  for(int i=0;i<int(V[0].size());++i)for(int j=0;j<int(V[1].size());++j){auto b=parity(V[0][i]&V[1][j]);adjacency[0][i*V[1].size()+j]=b;adjacency[1][j*V[0].size()+i]=b;}
 }
 int val(const int8_t*values,int side,int i)const{return values[(side?V[0].size():0)+i];}
 bool beta(int side,int i,int j)const{return adjacency[side][i*V[1-side].size()+j];}
 void span_certificate(SpanCertificate&out,int side,U w,const std::vector<int>&required,int forced,const int8_t*values)const{
  std::vector<int>live,degree;for(int i=0;i<int(V[side].size());++i)if(i!=forced&&val(values,side,i)>=0&&parity(V[side][i]&w)){live.push_back(i);int d=0;for(int j:required)d+=beta(side,i,j);degree.push_back(d);}
  std::vector<bool>keep(required.size(),true);
  for(int k=int(required.size())-1;k>=0;--k){int j=required[k];bool removable=true;for(int t=0;t<int(live.size());++t)if(beta(side,live[t],j)&&degree[t]<2){removable=false;break;}if(removable){keep[k]=false;for(int t=0;t<int(live.size());++t)if(beta(side,live[t],j))--degree[t];}}
  out={};out.kind=2;out.side=side;out.lo=uint64_t(w);out.hi=uint64_t(w>>64);
  for(int k=0;k<int(required.size());++k)if(keep[k])out.ids[out.count++]=required[k];
 }
 bool private_is_unit(const SpanCertificate&span,int omitted,const int8_t*values)const{
  Basis quotient;for(int k=0;k<span.count;++k){int j=span.ids[k];quotient.add(V[1-span.side][j],j);}U w=U(span.lo)|(U(span.hi)<<64);int unassigned=0;
  for(int i=0;i<int(V[span.side].size());++i)if(i!=omitted&&parity(V[span.side][i]&w)){
   bool zero=true;for(int k=0;k<span.count;++k)if(beta(span.side,i,span.ids[k])){zero=false;break;}
   if(zero){int value=val(values,span.side,i);if(value>0)return false;if(value==0&&++unassigned>1)return false;}
  }
  for(int j=0;j<int(V[1-span.side].size());++j)if(!quotient.reduce(w^V[1-span.side][j])){int value=val(values,1-span.side,j);if(value>0)return false;if(value==0&&++unassigned>1)return false;}
  return true;
 }
 int check(const int8_t*values,SpanCertificate*out,int cap)const{
  if(cap<=0)return 0;std::array<Basis,2>selected;std::array<std::vector<int>,2>required;
  for(int side=0;side<2;++side)for(int i=0;i<int(V[side].size());++i)if(val(values,side,i)>0){
   std::vector<int>circuit;if(!selected[side].add(V[side][i],i,&circuit)){out[0]={};out[0].kind=1;out[0].side=side;out[0].count=circuit.size();for(int k=0;k<int(circuit.size());++k)out[0].ids[k]=circuit[k];return 1;}required[side].push_back(i);
  }
  int count=0;
  for(int side=0;side<2&&count<cap;++side){
   Basis pool;std::vector<int>eligible;const auto&J=required[1-side];
   for(int i=0;i<int(V[side].size());++i)if(val(values,side,i)>=0){bool zero=true;for(int j:J)if(beta(side,i,j)){zero=false;break;}if(zero){eligible.push_back(i);pool.add(V[side][i],i);}}
   int needed=N-J.size();if(int(pool.original.size())>needed)return -2;
   if(int(pool.original.size())<needed){
    U w=0;for(int f=0;f<N&&!w;++f)if(!pool.r[f]){U candidate=pool.annihilator(f,N);if(selected[1-side].reduce(candidate))w=candidate;}
    if(!w)return -3;span_certificate(out[count++],side,w,J,-1,values);continue;
   }
   for(int k=0;k<int(pool.original.size())&&count<cap;++k){
    int i=pool.original[k];if((pool.twice>>k)&1||val(values,side,i)<0)continue;
    bool coloop=!((pool.used>>k)&1);U w=pool.dual(k,N);SpanCertificate span;span_certificate(span,side,w,J,i,values);
    if(private_is_unit(span,i,values)){out[count]=span;out[count].kind=3;out[count].omitted=i;++count;}
    if(coloop&&val(values,side,i)==0&&count<cap)out[count++]=span;
   }
  }
  return count;
 }
};
static std::vector<U>load(const uint64_t*lo,const uint64_t*hi,int n){std::vector<U>v(n);for(int i=0;i<n;++i)v[i]=U(lo[i])|(U(hi[i])<<64);return v;}
extern "C" void*c16_conditional_span_create(const uint64_t*xl,const uint64_t*xh,int nx,const uint64_t*zl,const uint64_t*zh,int nz,int N){return new ConditionalSpanContext(load(xl,xh,nx),load(zl,zh,nz),N);}
extern "C" void c16_conditional_span_destroy(void*p){delete static_cast<ConditionalSpanContext*>(p);}
extern "C" int c16_conditional_span_check(void*p,const int8_t*values,SpanCertificate*out,int cap){return static_cast<ConditionalSpanContext*>(p)->check(values,out,cap);}

// Direct-owner induced matching constraints: selected owners have degree one.
extern "C" int c16_owner_matching_check(void*p,const int8_t*values,int*out,int cap){
 auto*c=static_cast<ConditionalSpanContext*>(p);if(cap<=0)return 0;
 // Search all selected owners for an immediate conflict before unit clauses.
 for(int side=0;side<2;++side)for(int i=0;i<int(c->V[side].size());++i)if(c->val(values,side,i)>0){
  int first=-1;for(int j=0;j<int(c->V[1-side].size());++j)if(c->beta(side,i,j)&&c->val(values,1-side,j)>0){
   if(first>=0){out[0]=side;out[1]=i;out[2]=first;out[3]=j;return 1;}first=j;
  }
 }
 int count=0;
 for(int side=0;side<2&&count<cap;++side)for(int i=0;i<int(c->V[side].size())&&count<cap;++i)if(c->val(values,side,i)>0){
  int first=-1;for(int j=0;j<int(c->V[1-side].size());++j)if(c->beta(side,i,j)&&c->val(values,1-side,j)>0){first=j;break;}
  if(first<0)continue;
  for(int j=0;j<int(c->V[1-side].size())&&count<cap;++j)if(c->beta(side,i,j)&&c->val(values,1-side,j)==0){int*k=out+4*count++;k[0]=side;k[1]=i;k[2]=first;k[3]=j;}
 }
 return count;
}
