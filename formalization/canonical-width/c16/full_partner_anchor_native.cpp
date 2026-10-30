// Exact anchored partner-basis batches. No floating arithmetic.
#include <algorithm>
#include <cstdint>
#include <climits>
#include <vector>
#include <new>
using U=__uint128_t; using I=__int128_t;
static int pivot(U x){uint64_t h=(uint64_t)(x>>64);return h?127-__builtin_clzll(h):63-__builtin_clzll((uint64_t)x);}
static bool add(U *rows,U x){while(x){int p=pivot(x);if(rows[p])x^=rows[p];else{rows[p]=x;return true;}}return false;}
static int rank(const std::vector<U>&V,const std::vector<int>&ids){U r[128]={};int n=0;for(int i:ids)n+=add(r,V[i]);return n;}
static bool cast(I x,int64_t&v){if(x<(I)INT64_MIN||x>(I)INT64_MAX)return false;v=(int64_t)x;return true;}
struct D {int status=0,need=0,fixed=-1;std::vector<int> zero;std::vector<std::vector<int>> bins;};
struct C {int n,nx,nz,N,anchor;std::vector<U>X,Z;std::vector<std::vector<int>> selected;std::vector<D> d;};
extern "C" {
void* c16_anchor_create(const uint64_t*xl,const uint64_t*xh,int nx,const uint64_t*zl,const uint64_t*zh,int nz,int n,const int*offset,const int*indices,int N,int anchor){
 try{
 if(n<1||n>128||nx<1||nz<1||N<1||anchor<0||anchor>=nz||offset[0]!=0)return nullptr;
 C*c=new C;c->n=n;c->nx=nx;c->nz=nz;c->N=N;c->anchor=anchor;
 for(int i=0;i<nx;i++)c->X.push_back((U(xh[i])<<64)|xl[i]);for(int j=0;j<nz;j++)c->Z.push_back((U(zh[j])<<64)|zl[j]);
 for(int t=0;t<N;t++){
  if(offset[t+1]<offset[t]||offset[t+1]-offset[t]>128){delete c;return nullptr;}
  std::vector<int>P(indices+offset[t],indices+offset[t+1]);for(int i:P)if(i<0||i>=nx){delete c;return nullptr;}c->selected.push_back(P);D base;base.need=n-(int)P.size();base.bins.resize(P.size());U sig=0;
  if(rank(c->X,P)!=(int)P.size())base.status=1;
  else{
   for(int j=0;j<nz;j++){U s=0;for(int h=0;h<(int)P.size();h++)if(__builtin_popcountll((uint64_t)(c->X[P[h]]&c->Z[j]))%2 ^ __builtin_popcountll((uint64_t)((c->X[P[h]]&c->Z[j])>>64))%2)s|=U(1)<<h;if(j==anchor)sig=s;if(!s)base.zero.push_back(j);else if(!(s&(s-1)))base.bins[pivot(s)].push_back(j);}
   if(rank(c->Z,base.zero)!=base.need)base.status=2;else for(auto&b:base.bins)if(b.empty()){base.status=3;break;}
  }
  for(int state=0;state<2;state++){
   D d=base;
   if(!d.status){
    if(state){if(sig&&(sig&(sig-1)))d.status=4;else if(!sig){if(!c->Z[anchor])d.status=5;else{d.fixed=anchor;d.zero.erase(std::remove(d.zero.begin(),d.zero.end(),anchor),d.zero.end());}}else d.bins[pivot(sig)]={anchor};}
    else{d.zero.erase(std::remove(d.zero.begin(),d.zero.end(),anchor),d.zero.end());for(auto&b:d.bins)b.erase(std::remove(b.begin(),b.end(),anchor),b.end());}
    if(!d.status){auto z=d.zero;if(d.fixed>=0)z.push_back(d.fixed);if(rank(c->Z,z)!=d.need)d.status=6;else for(auto&b:d.bins)if(b.empty()){d.status=7;break;}}
   }c->d.push_back(std::move(d));
  }
 }return c;
 }catch(...){return nullptr;}
}
void c16_anchor_destroy(void*p){delete static_cast<C*>(p);}
void c16_anchor_status(void*p,int*status){C*c=static_cast<C*>(p);for(int t=0;t<2*c->N;t++)status[t]=c->d[t].status;}
static int support(C*c,int t,const int64_t*w,int*status,int64_t*value,int*out){
 const D&d=c->d[t];*status=d.status;std::fill(out,out+c->n,-1);*value=0;if(d.status)return 0;
 U rows[128]={};int used=0;if(d.fixed>=0){if(!add(rows,c->Z[d.fixed]))return -3;out[used++]=d.fixed;}
 auto order=d.zero;std::sort(order.begin(),order.end(),[w](int i,int j){return w[i]!=w[j]?w[i]>w[j]:i<j;});
 for(int j:order){if(used==d.need)break;if(add(rows,c->Z[j]))out[used++]=j;}if(used!=d.need)return -3;
 for(const auto&b:d.bins){int best=b[0];for(int j:b)if(w[j]>w[best]||(w[j]==w[best]&&j<best))best=j;out[used++]=best;}
 if(used!=c->n)return -3;I sum=0;for(int i=0;i<used;i++)sum+=(I)w[out[i]];return cast(sum,*value)?0:-2;
}
int c16_anchor_batch(void*p,const int64_t*w,int*status,int64_t*value,int*bases){C*c=static_cast<C*>(p);if(!c)return -1;try{for(int t=0;t<2*c->N;t++){int e=support(c,t,w+(size_t)t*c->nz,status+t,value+t,bases+(size_t)t*c->n);if(e)return e;}return 0;}catch(...){return -1;}}
int c16_anchor_feasible_batch(void*p,const int*queries,int count,const int64_t*w,int64_t*value,int*bases){C*c=static_cast<C*>(p);if(!c)return -1;try{for(int t=0;t<count;t++){int q=queries[t],status;if(q<0||q>=2*c->N||c->d[q].status)return -1;int e=support(c,q,w+(size_t)t*c->nz,&status,value+t,bases+(size_t)t*c->n);if(e)return e;}return 0;}catch(...){return -1;}}
int c16_anchor_price(void*p,const uint16_t*masks,int orbit,const int64_t*coef,int*status,int64_t*value,int64_t*full,int*bases){
 C*c=static_cast<C*>(p);if(!c||c->nx!=720||c->nz!=720||orbit<0||orbit>=45)return -1;
 try{std::vector<int64_t>w(720);for(int t=0;t<c->N;t++){
  unsigned mask=masks[t];std::vector<int>P;for(int h=0;h<16;h++)if(mask>>h&1)P.push_back(16*orbit+h);if(P!=c->selected[t])return -1;
  I constant=coef[0]+I(coef[1])*__builtin_popcount(mask);for(int h=1;h<=8;h++){unsigned r=((mask<<h)|(mask>>(16-h)))&65535;constant+=I(coef[h+1])*__builtin_popcount(mask&r);}
  for(int state=0;state<2;state++){
   I branch=constant;if(state){branch+=coef[775];for(int h=0;h<16;h++)if(mask>>h&1)branch+=coef[776+h];}
   int q=2*t+state;if(c->d[q].status){status[q]=c->d[q].status;value[q]=full[q]=0;std::fill(bases+(size_t)q*c->n,bases+(size_t)(q+1)*c->n,-1);continue;}
   for(int j=0;j<45;j++)for(int b=0;b<16;b++){I x=coef[10+j];for(int h=0;h<16;h++)if(mask>>h&1)x+=coef[55+16*j+(b-h+16)%16];if(state)x+=coef[792+16*j+b];if(!cast(x,w[16*j+b]))return -2;}
   int e=support(c,q,w.data(),status+q,value+q,bases+(size_t)q*c->n);if(e)return e;if(!cast(branch+(I)value[q],full[q]))return -2;
  }
 }return 0;}catch(...){return -1;}
}
}
