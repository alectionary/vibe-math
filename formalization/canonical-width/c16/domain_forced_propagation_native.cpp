// C ABI for the optional full mandatory-pool propagator.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include "quotient_fast.h"
#include "quotient_prepared.h"
#include "quotient_coloop.h"
#include "domain_forced_propagation.h"
struct Context{
 static std::vector<Bits> allowed(const uint64_t*flat,int nx,int words){std::vector<Bits> out(nx);for(int i=0;i<nx;++i)for(int w=0;w<words;++w)out[i].w[w]=flat[i*words+w];return out;}
 std::vector<U>X,Z;DomainForcedPropagation fp;
 static std::vector<U> loadraw(const uint64_t*lo,const uint64_t*hi,int n){std::vector<U>v;for(int i=0;i<n;++i)v.push_back((U(hi[i])<<64)|lo[i]);return v;}
 Context(const uint64_t*xl,const uint64_t*xh,int nx,const uint64_t*zl,const uint64_t*zh,int nz,int d,const uint64_t*domain,int words):X(loadraw(xl,xh,nx)),Z(loadraw(zl,zh,nz)),fp(X,Z,d,allowed(domain,nx,words)){}
};
extern "C" void* c16_domain_propagation_create(const uint64_t*xl,const uint64_t*xh,int nx,const uint64_t*zl,const uint64_t*zh,int nz,int d,const uint64_t*domain,int words){return new Context(xl,xh,nx,zl,zh,nz,d,domain,words);}
extern "C" void c16_domain_propagation_destroy(void*p){delete static_cast<Context*>(p);}
extern "C" int c16_domain_propagation_check(void*p,const uint64_t*bits,int words,int*out){
 auto&fp=static_cast<Context*>(p)->fp;Bits req;for(int w=0;w<words;++w)req.w[w]=bits[w];
 if(fp.run(req).possible)return -1;
 std::vector<int>ids;req.each([&](int i){ids.push_back(i);});
 for(int i:ids){Bits next=req;next.reset(i);if(!fp.run(next).possible)req=next;}
 int count=0;req.each([&](int i){out[count++]=i;});return count;
}
