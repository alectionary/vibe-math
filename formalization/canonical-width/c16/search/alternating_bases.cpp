// Construction experiment: alternate minimum-weight vector bases, where a
// vector's weight is its number of anticommutations with the opposite basis.
// The two 128-dimensional bases have invertible Gram matrix, so energy>=128;
// equality is exactly a canonical frame. Random ties and forced-vector kicks
// explore different local minima. Failure is not an exclusion.
#define main legacy_seed4_main
#include "../seed4_fifteen.cpp"
#undef main
#include <random>
#include <numeric>
#include <chrono>
int main(int argc,char**argv){
    if(argc<4)return 1;auto X=load(argv[1]),Z=load(argv[2]);std::string output=argv[3];
    double seconds=argc>4?std::stod(argv[4]):600;uint64_t seed=argc>5?std::stoull(argv[5]):1;
    std::mt19937_64 rng(seed);std::vector<Bits> xa(X.size()),za(Z.size());
    for(int i=0;i<(int)X.size();++i)for(int j=0;j<(int)Z.size();++j)if(dot(X[i],Z[j])){xa[i].set(j);za[j].set(i);}
    auto select=[&](const std::vector<U>&V,const std::vector<Bits>&anti,const std::vector<int>&other,int kick){
        Bits chosen;for(int j:other)chosen.set(j);std::vector<std::pair<uint64_t,int>>order;
        for(int i=0;i<(int)V.size();++i){Bits hits=anti[i];hits.keep(chosen);order.push_back({(uint64_t(hits.count())<<32)|uint32_t(rng()),i});}
        std::sort(order.begin(),order.end());GE g;std::vector<int> basis;basis.reserve(128);
        for(int k=0;k<kick;++k){int i=rng()%V.size();if(g.insert(V[i]))basis.push_back(i);}
        for(auto[score,i]:order)if(g.n<128 && g.insert(V[i]))basis.push_back(i);
        if(basis.size()!=128)std::exit(2);return basis;
    };
    int best=100000,bestPartial=0;std::vector<int> incumbentX,incumbentZ;
    uint64_t rounds=0,updates=0;auto start=std::chrono::steady_clock::now();
    auto elapsed=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};
    auto evaluate=[&](const std::vector<int>&I,const std::vector<int>&J){
        Bits bx,bz;for(int i:I)bx.set(i);for(int j:J)bz.set(j);
        int energy=0;std::vector<std::pair<int,int>> isolated;
        for(int i:I){Bits hits=xa[i];hits.keep(bz);int d=hits.count();energy+=d;
            if(d==1){int mate=-1;hits.each([&](int j){mate=j;});Bits back=za[mate];back.keep(bx);if(back.count()==1)isolated.push_back({i,mate});}}
        if(energy<128)std::exit(3);
        bool improve=energy<best,partial=(int)isolated.size()>bestPartial;
        if(improve){best=energy;incumbentX=I;incumbentZ=J;}
        if(partial)bestPartial=isolated.size();
        if(improve || partial){
            std::cout<<"best_energy "<<best<<" best_partial "<<bestPartial<<" current_energy "<<energy<<" rounds "<<rounds<<" updates "<<updates<<" seconds "<<elapsed()<<std::endl;
            if(improve){std::ofstream out(output+".basis.json");out<<"{\"energy\":"<<energy<<",\"X_basis\":[";
                for(int k=0;k<128;++k)out<<(k?",":"")<<I[k];out<<"],\"Z_basis\":[";for(int k=0;k<128;++k)out<<(k?",":"")<<J[k];out<<"]}\n";}
            if(partial){std::ofstream out(output+".partial.json");out<<"{\"pool_pairs\":[";bool comma=false;
                for(auto[i,j]:isolated){if(comma)out<<",";comma=true;out<<"["<<i<<","<<j<<"]";}out<<"]}\n";}
        }
        if(energy==128){
            if(isolated.size()!=128)std::exit(4);std::ofstream out(output+".frame.json");out<<"{\"pool_pairs\":[";
            bool comma=false;for(auto[i,j]:isolated){if(comma)out<<",";comma=true;out<<"["<<i<<","<<j<<"]";}out<<"]}\n";
        }
        return energy;
    };
    std::vector<int> I,J;
    while(elapsed()<seconds && best>128){
        ++rounds;int kick=4*(1+rounds%8);
        if(rounds%5==1 || incumbentX.empty()){J=select(Z,za,{},128);I=select(X,xa,J,0);}
        else{J=select(Z,za,incumbentX,kick);I=select(X,xa,J,0);}
        int old=100000,flat=0;
        for(int t=0;t<100 && elapsed()<seconds;++t){
            J=select(Z,za,I,0);I=select(X,xa,J,0);++updates;int e=evaluate(I,J);
            if(e==128)break;if(e<old)flat=0;else ++flat;old=e;if(flat>=12)break;
        }
    }
    std::cout<<"DONE energy "<<best<<" partial "<<bestPartial<<" rounds "<<rounds<<" updates "<<updates<<" seconds "<<elapsed()<<" seed "<<seed<<"\n";
}
