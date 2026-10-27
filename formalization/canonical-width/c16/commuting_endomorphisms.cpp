// Linear support-preserving deformations of the rank128 pairing factorization.
// C_ij=z_j^T L x_i must vanish on every commuting pool pair. Nontrivial L
// with a non-binary eigenvalue would give a lower-rank weighted support model.
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
    int rank=0,edges=0;std::vector<std::pair<int,int>>independent;
    for(int i=0;i<(int)X.size() && rank<16383;++i)for(int j=0;j<(int)Z.size() && rank<16383;++j)if(!dot(X[i],Z[j])) {
        ++edges;auto a=reduce(outer(X[i],Z[j]));int p=a.top();
        if(p>=0){used[p]=1;piv[p]=a;++rank;independent.push_back({i,j});}
    }
    std::cout<<"commuting_pairs_scanned "<<edges<<" span_rank "<<rank<<" endomorphism_dimension "<<16384-rank<<"\n";
    if(argc>3){std::ofstream out(std::string(argv[3])+".pairs");for(auto[i,j]:independent)out<<i<<" "<<j<<"\n";}
    int dim=0;
    for(int free=0;free<16384;++free)if(!used[free]){
        Matrix L;L.w[free/64]|=1ull<<(free%64);
        for(int p=0;p<16384;++p)if(used[p]){int bit=0;for(int k=0;k<=p/64;++k)bit^=pop2(piv[p].w[k]&L.w[k])&1;if(bit)L.w[p/64]^=1ull<<(p%64);}
        for(U x:X){U value=0;for(int r=0;r<128;++r){U row=U(L.w[2*r])|(U(L.w[2*r+1])<<64);value|=U(dot(row,x))<<r;}for(U z:Z)if(!dot(x,z)&&dot(value,z))return 1;}
        if(argc>3){std::ofstream out(std::string(argv[3])+".kernel-"+std::to_string(dim)+".txt");for(int r=0;r<128;++r){char line[40];std::snprintf(line,sizeof(line),"%016llx%016llx\n",(unsigned long long)L.w[2*r+1],(unsigned long long)L.w[2*r]);out<<line;}}
        ++dim;
    }
    std::cout<<"ALL_ENDOMORPHISM_BASIS_VECTORS_CHECKED "<<dim<<"\n";return 0;
}
