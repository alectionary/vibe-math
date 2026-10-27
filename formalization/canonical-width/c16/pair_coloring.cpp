// Greedy coloring of the compatibility graph on all anticommuting pool pairs.
// An r-pair frame is an r-clique, so a verified coloring with <128 colors
// would exclude a full frame. Larger color counts give no exclusion.
#define main legacy_seed4_main
#include "seed4_fifteen.cpp"
#undef main
#include <random>
int main(int argc,char** argv) {
    if(argc<3)return 1;
    auto X=load(argv[1]),Z=load(argv[2]);
    std::vector<std::pair<int,int>> es;
    for(int i=0;i<(int)X.size();++i)for(int j=0;j<(int)Z.size();++j)
        if(dot(X[i],Z[j]))es.push_back({i,j});
    int nw=(es.size()+63)/64;
    std::vector<std::vector<uint64_t>> badX(Z.size(),std::vector<uint64_t>(nw)),
        badZ(X.size(),std::vector<uint64_t>(nw));
    for(int j=0;j<(int)Z.size();++j)for(int e=0;e<(int)es.size();++e)
        if(dot(X[es[e].first],Z[j]))badX[j][e/64]|=1ull<<(e%64);
    for(int i=0;i<(int)X.size();++i)for(int e=0;e<(int)es.size();++e)
        if(dot(X[i],Z[es[e].second]))badZ[i][e/64]|=1ull<<(e%64);
    std::vector<int> order(es.size());
    for(int i=0;i<(int)es.size();++i)order[i]=i;
    std::mt19937 gen(argc>3?std::strtoul(argv[3],nullptr,0):0);
    if(argc>3)std::shuffle(order.begin(),order.end(),gen);
    std::vector<std::vector<uint64_t>> allowed;
    std::vector<std::vector<int>> classes;
    for(int e:order){
        auto [i,j]=es[e];int c=0;
        for(;c<(int)allowed.size();++c)if((allowed[c][e/64]>>(e%64))&1)break;
        if(c==(int)allowed.size()){
            allowed.push_back(std::vector<uint64_t>(nw,~0ull));classes.push_back({});
        }
        classes[c].push_back(e);
        for(int w=0;w<nw;++w)allowed[c][w]&=badX[j][w]|badZ[i][w];
    }
    // Direct independent pairwise test of the color classes.
    for(const auto& cls:classes)for(int e:cls)for(int f:cls)if(e!=f){
        auto[i,j]=es[e];auto[a,b]=es[f];
        if(!dot(X[i],Z[b])&&!dot(X[a],Z[j])){std::cerr<<"INVALID\n";return 1;}
    }
    std::cout<<"edges "<<es.size()<<" colors "<<classes.size()<<" verified\n";
    if(argc>4){std::ofstream out(argv[4]);for(int c=0;c<(int)classes.size();++c)
        for(int e:classes[c])out<<es[e].first<<" "<<es[e].second<<" "<<c<<"\n";}
}
