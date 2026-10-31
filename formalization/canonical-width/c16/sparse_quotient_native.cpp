// Exact sparse evaluations of a binary residual source pool, through weight3.
// Native discovery only: every obstruction is reconstructed by Python.
#include <algorithm>
#include <array>
#include <cstdint>
#include <unordered_map>
#include <unordered_set>
#include <vector>
using U = unsigned __int128;
static int parity(U x) { return (__builtin_popcountll(uint64_t(x))+__builtin_popcountll(uint64_t(x>>64)))&1; }
static int high(U x) { return x>>64 ? 127-__builtin_clzll(uint64_t(x>>64)) : 63-__builtin_clzll(uint64_t(x)); }
struct UHash { size_t operator()(U x) const { return uint64_t(x)^(uint64_t(x>>64)*0x9e3779b97f4a7c15ULL); } };
struct Basis {
  std::array<U,128> rows{}, tags{};
  std::vector<int> original;
  bool add(U v,int id,U* representation=nullptr) {
    U comb=0;
    while(v) {
      int p=high(v);
      if(!rows[p]) {
        int k=original.size(); rows[p]=v; tags[p]=comb^(U(1)<<k); original.push_back(id);
        if(representation) *representation=0;
        return true;
      }
      v^=rows[p]; comb^=tags[p];
    }
    if(representation) *representation=comb;
    return false;
  }
  U canonical(U v) const {
    U out=0;
    while(v) { int p=high(v); if(rows[p]) v^=rows[p]; else { out|=U(1)<<p; v^=U(1)<<p; } }
    return out;
  }
  U dual(int k,int N) const {
    U w=0;
    for(int p=0;p<N;++p) if(rows[p] && parity(rows[p]&w)!=int((tags[p]>>k)&1)) w^=U(1)<<p;
    return w;
  }
  U annihilator(int f,int N) const {
    U w=U(1)<<f;
    for(int p=0;p<N;++p) if(rows[p] && parity(rows[p]&w)) w^=U(1)<<p;
    return w;
  }
};
using Signature=std::array<uint64_t,16>;
struct SigHash {
  size_t operator()(Signature const& s) const {
    size_t h=0xcbf29ce484222325ULL;
    for(auto v:s) { h^=v; h*=0x100000001b3ULL; }
    return h;
  }
};
static Signature xor_sig(Signature const&a,Signature const&b) { Signature c{}; for(int i=0;i<16;++i)c[i]=a[i]^b[i];return c; }
static int weight(Signature const&s,int stop) { int n=0;for(auto x:s){n+=__builtin_popcountll(x);if(n>stop)break;}return n; }
struct Certificate { uint64_t lo,hi; int kind,side,count,omitted; int ids[129]; };
struct Context {
  int N;
  std::array<std::vector<U>,2> V;
  Context(std::vector<U> x,std::vector<U> z,int n):N(n),V{std::move(x),std::move(z)}{}
  int probe(int side,const int*ids,int count,int order,Certificate*out,int cap) const {
    if(side<0||side>1||count<0||count>N||order<1||order>3||cap<1||V[side].size()>1024)return -1;
    Basis J;
    for(int k=0;k<count;++k) {
      if(ids[k]<0||ids[k]>=int(V[1-side].size())||!J.add(V[1-side][ids[k]],ids[k]))return -2;
    }
    Basis pool;
    std::vector<U> nonbasis;
    for(int i=0;i<int(V[side].size());++i) {
      bool zero=true;
      for(int k=0;k<count;++k)if(parity(V[side][i]&V[1-side][ids[k]])){zero=false;break;}
      if(!zero)continue;
      U coefficients;
      if(!pool.add(V[side][i],i,&coefficients))nonbasis.push_back(coefficients);
    }
    int rank=pool.original.size(), needed=N-count;
    if(rank>needed)return -3;
    auto save=[&](U w,int q,int& found){
      auto &r=out[found++];r={};r.lo=uint64_t(w);r.hi=uint64_t(w>>64);r.kind=5;r.side=side;r.count=count;r.omitted=q;
      for(int k=0;k<count;++k)r.ids[k]=ids[k];
    };
    int found=0;
    if(rank<needed) {
      for(int f=0;f<N;++f)if(!pool.rows[f]) {
        U w=pool.annihilator(f,N);
        if(J.canonical(w)){save(w,0,found);return found;}
      }
      return -4;
    }
    std::unordered_set<U,UHash> labels;
    labels.insert(0);
    for(U z:V[1-side])labels.insert(J.canonical(z));
    std::vector<U> single(labels.begin(),labels.end());
    std::unordered_set<U,UHash> pairs;
    bool pairs_ready=false;
    auto representable=[&](U w,int q){
      U target=J.canonical(w);
      if(!target)return true;
      if(labels.count(target))return true;
      if(q==1)return false;
      for(U v:single)if(labels.count(target^v))return true;
      if(q==2)return false;
      if(!pairs_ready) {
        pairs.reserve(single.size()*(single.size()+1)/2);
        for(size_t i=0;i<single.size();++i)for(size_t j=i;j<single.size();++j)pairs.insert(single[i]^single[j]);
        pairs_ready=true;
      }
      for(U v:single)if(pairs.count(target^v))return true;
      return false;
    };
    std::vector<Signature> columns(rank);
    for(size_t t=0;t<nonbasis.size();++t)for(int k=0;k<rank;++k)if((nonbasis[t]>>k)&1)columns[k][t/64]|=uint64_t(1)<<(t%64);
    std::vector<U> dual(rank);
    for(int k=0;k<rank;++k)dual[k]=pool.dual(k,N);
    for(int i=0;i<rank&&found<cap;++i) {
      int q=1+weight(columns[i],order-1);
      if(q<=order&&!representable(dual[i],q))save(dual[i],q,found);
    }
    if(order>=2)for(int i=0;i<rank&&found<cap;++i)for(int j=i+1;j<rank&&found<cap;++j) {
      int q=2+weight(xor_sig(columns[i],columns[j]),order-2);
      if(q<=order&&!representable(dual[i]^dual[j],q))save(dual[i]^dual[j],q,found);
    }
    if(order==3&&found<cap) {
      std::unordered_map<Signature,std::vector<int>,SigHash> lookup;
      for(int k=0;k<rank;++k)lookup[columns[k]].push_back(k);
      for(int i=0;i<rank&&found<cap;++i)for(int j=i+1;j<rank&&found<cap;++j) {
        auto it=lookup.find(xor_sig(columns[i],columns[j]));
        if(it==lookup.end())continue;
        for(int k:it->second)if(k>j&&found<cap) {
          U w=dual[i]^dual[j]^dual[k];if(!representable(w,3))save(w,3,found);
        }
      }
    }
    return found;
  }
};
static std::vector<U> load(const uint64_t*lo,const uint64_t*hi,int n){std::vector<U>v(n);for(int i=0;i<n;++i)v[i]=U(lo[i])|(U(hi[i])<<64);return v;}
extern "C" void*c16_sparse_create(const uint64_t*xl,const uint64_t*xh,int nx,const uint64_t*zl,const uint64_t*zh,int nz,int N){if(N<1||N>128)return nullptr;return new Context(load(xl,xh,nx),load(zl,zh,nz),N);}
extern "C" void c16_sparse_destroy(void*p){delete static_cast<Context*>(p);}
extern "C" int c16_sparse_probe(void*p,int side,const int*ids,int count,int order,Certificate*out,int cap){return static_cast<Context*>(p)->probe(side,ids,count,order,out,cap);}
