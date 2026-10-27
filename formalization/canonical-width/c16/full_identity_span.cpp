// Test I_128 in span{z x^T : pool x,z anticommute}, over F_2.
// A dual basis must sum to I_128. Failure supplies a separating linear
// functional, checked directly against every allowed outer product.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
struct Matrix {
    uint64_t w[256]{};
    int top() const {
        for(int k=255;k>=0;--k)if(w[k])return k*64+63-__builtin_clzll(w[k]);
        return -1;
    }
};
static Matrix outer(U x,U z) {
    Matrix a;
    for(int r=0;r<128;++r)if((z>>r)&1){a.w[2*r]=(uint64_t)x;a.w[2*r+1]=(uint64_t)(x>>64);}
    return a;
}
int main(int argc,char** argv) {
    if(argc<3)return 1;
    auto X=load(argv[1]),Z=load(argv[2]);
    std::vector<Matrix> piv(16384);
    std::vector<char> used(16384);
    auto reduce=[&](Matrix a) {
        while(true) {
            int p=a.top();if(p<0 || !used[p])return a;
            for(int k=0;k<=p/64;++k)a.w[k]^=piv[p].w[k];
        }
    };
    int rank=0,edges=0;
    for(U x:X)for(U z:Z)if(dot(x,z)) {
        ++edges;auto a=reduce(outer(x,z));int p=a.top();
        if(p>=0){used[p]=1;piv[p]=a;++rank;}
    }
    Matrix target;
    for(int i=0;i<128;++i){int bit=i*128+i;target.w[bit/64]|=1ull<<(bit%64);}
    Matrix rem=reduce(target);
    std::cout<<"edges "<<edges<<" rank "<<rank<<" identity_in_span "<<(rem.top()<0)<<"\n";
    if(rem.top()<0)return 0;
    Matrix L;
    int free=rem.top();L.w[free/64]|=1ull<<(free%64);
    for(int p=0;p<16384;++p)if(used[p]) {
        int bit=0;for(int k=0;k<=p/64;++k)bit^=pop2(piv[p].w[k]&L.w[k])&1;
        if(bit)L.w[p/64]^=1ull<<(p%64);
    }
    int trace=0;
    for(int i=0;i<128;++i){int b=i*128+i;trace^=(L.w[b/64]>>(b%64))&1;}
    if(trace!=1)return 1;
    for(U x:X) {
        U value=0;
        for(int r=0;r<128;++r){U row=U(L.w[2*r])|(U(L.w[2*r+1])<<64);value|=U(dot(row,x))<<r;}
        for(U z:Z)if(dot(x,z)&&dot(value,z))return 1;
    }
    std::cout<<"SEPARATING_FUNCTIONAL_VERIFIED\n";
    if(argc>3) {
        std::ofstream out(argv[3]);
        for(int r=0;r<128;++r) {
            char line[40];std::snprintf(line,sizeof(line),"%016llx%016llx\n",
                (unsigned long long)L.w[2*r+1],(unsigned long long)L.w[2*r]);out<<line;
        }
    }
}
