// Independent implementation of the syndrome-directed circuit enumeration
// described by Lee, arXiv:2610.06820v1 Appendix A. No released engine code is
// imported. In-place bans partition branches; disjoint odd-check neighborhoods
// give a certified lower bound on the remaining support size.
#include <algorithm>
#include <array>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <functional>
#include <iostream>
#include <set>
#include <string>
#include <vector>
using U=unsigned __int128;
struct Mask{
    std::array<uint64_t,17>w{};
    bool operator<(const Mask&b)const{for(int k=16;k>=0;--k)if(w[k]!=b.w[k])return w[k]<b.w[k];return false;}
};
int main(int argc,char**argv){
    if(argc<3){std::cerr<<"usage: enumerate_physical input output [W=17] [first_root=0] [end_root=blocks] [seconds=1800]\n";return 1;}
    std::ifstream in(argv[1]);int N,R,K,P;in>>N>>R>>K>>P;
    if(!in || N>1088 || R>1024 || K>128 || P>64 || P<1 || N%P)return 1;
    std::vector<std::vector<int>> rows(R),cols(N);std::vector<U> logical(N);
    for(int c=0;c<R;++c){int n;in>>n;for(int k=0;k<n;++k){int q;in>>q;if(q<0||q>=N)return 1;rows[c].push_back(q);cols[q].push_back(c);}}
    for(int k=0;k<K;++k){int n;in>>n;for(int j=0;j<n;++j){int q;in>>q;if(q<0||q>=N)return 1;logical[q]^=U(1)<<k;}}
    if(!in)return 1;
    int W=argc>3?std::stoi(argv[3]):17,first=argc>4?std::stoi(argv[4]):0,end=argc>5?std::stoi(argv[5]):N/P;
    double seconds=argc>6?std::stod(argv[6]):1800;
    int maxcol=0;for(auto&v:cols)maxcol=std::max(maxcol,(int)v.size());
    std::vector<char> forbidden(N),odd(R);std::vector<int> live(R),support;
    std::array<uint64_t,16> syndrome{};int oddcount=0;
    uint64_t nodes=0,zeros=0,logical_leaves=0,pruned_pack=0,pruned_budget=0;
    U label=0;bool capped=false;std::set<Mask> pool;
    auto start=std::chrono::steady_clock::now();
    auto elapsed=[&](){return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};
    auto ban=[&](int v){if(forbidden[v])std::exit(3);forbidden[v]=1;for(int c:cols[v])--live[c];};
    auto unban=[&](int v){if(!forbidden[v])std::exit(3);forbidden[v]=0;for(int c:cols[v])++live[c];};
    auto flip=[&](int v){for(int c:cols[v]){oddcount+=odd[c]?-1:1;odd[c]^=1;syndrome[c/64]^=1ull<<(c%64);}label^=logical[v];};
    auto normalize=[&](){
        Mask best;bool have=false;
        for(int h=0;h<P;++h){Mask word;for(int q:support){int v=(q/P)*P+(q%P+h)%P;word.w[v/64]|=1ull<<(v%64);}
            if(!have || word<best){best=word;have=true;}}
        return best;
    };
    std::function<void()> rec=[&](){
        if(capped)return;++nodes;
        if((nodes&65535)==0 && elapsed()>=seconds){capped=true;return;}
        int left=W-support.size();
        if(!oddcount){++zeros;if(label){++logical_leaves;auto word=normalize();if(pool.insert(word).second)
            std::cerr<<"logical orbit "<<pool.size()<<" weight "<<support.size()<<" nodes "<<nodes<<" seconds "<<elapsed()<<"\n";}return;}
        if(!left || oddcount>left*maxcol){++pruned_budget;return;}
        int best=-1,minlive=100000;std::vector<int> unsatisfied;unsatisfied.reserve(128);
        for(int w=0;w<(R+63)/64;++w){uint64_t bits=syndrome[w];while(bits){int c=w*64+__builtin_ctzll(bits);bits&=bits-1;
            if(!live[c])return;unsatisfied.push_back(c);if(live[c]<minlive){minlive=live[c];best=c;}}}
        if(best<0)return;
        // Pairwise-disjoint live neighborhoods require distinct new variables.
        if(oddcount>left){
            std::array<uint64_t,17> covered{};int packed=0;
            auto pack=[&](int c){for(int v:rows[c])if(!forbidden[v] && ((covered[v/64]>>(v%64))&1))return;
                ++packed;for(int v:rows[c])if(!forbidden[v])covered[v/64]|=1ull<<(v%64);};
            pack(best);for(int c:unsatisfied)if(c!=best){pack(c);if(packed>left){++pruned_pack;return;}}
        }
        std::vector<std::pair<int,int>> order;order.reserve(rows[best].size());
        for(int v:rows[best])if(!forbidden[v]){int cover=0;for(int c:cols[v])cover+=odd[c];order.push_back({(int)cols[v].size()-2*cover,v});}
        std::sort(order.begin(),order.end());
        std::vector<int> banned;banned.reserve(order.size());
        for(auto[score,v]:order){
            if(capped)break;ban(v);banned.push_back(v);support.push_back(v);flip(v);rec();flip(v);support.pop_back();
        }
        for(int v:banned)unban(v);
    };
    for(int root=first;root<end;++root){
        std::fill(forbidden.begin(),forbidden.end(),0);std::fill(odd.begin(),odd.end(),0);syndrome.fill(0);oddcount=0;label=0;support.clear();
        for(int c=0;c<R;++c)live[c]=rows[c].size();
        for(int v=0;v<=root*P;++v)ban(v);
        support.push_back(root*P);flip(root*P);uint64_t before=nodes;rec();
        std::cerr<<"root "<<root<<" "<<(capped?"INCOMPLETE":"COMPLETE")<<" nodes "<<nodes-before<<" seconds "<<elapsed()<<" orbits "<<pool.size()<<"\n";
        if(capped)break;
    }
    std::ofstream out(argv[2]);out<<"{\"complete\":"<<(capped?"false":"true")<<",\"W\":"<<W<<",\"first_root\":"<<first<<",\"end_root\":"<<end
        <<",\"nodes\":"<<nodes<<",\"zero_leaves\":"<<zeros<<",\"logical_leaves\":"<<logical_leaves<<",\"pruned_pack\":"<<pruned_pack
        <<",\"pruned_budget\":"<<pruned_budget<<",\"seconds\":"<<elapsed()<<",\"masks_hex\":[";
    bool comma=false;for(const auto&word:pool){if(comma)out<<",";comma=true;out<<"\"";char buf[17];
        for(int k=16;k>=0;--k){std::snprintf(buf,sizeof(buf),"%016llx",(unsigned long long)word.w[k]);out<<buf;}out<<"\"";}
    out<<"]}\n";std::cout<<(capped?"INCOMPLETE":"COMPLETE")<<" roots "<<first<<":"<<end<<" nodes "<<nodes<<" orbits "<<pool.size()<<" seconds "<<elapsed()<<"\n";
    return capped?2:0;
}
