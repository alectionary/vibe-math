#include <vector>
#include <array>
#include <set>
#include <algorithm>
#include <fstream>
#include <iostream>
#include <random>
#include <chrono>
using T=std::array<int,5>;
int main(int argc,char**argv){std::ifstream in(argv[1]);int N,P;in>>N>>P;int V=N*P;std::vector<double>p(N),C(P*N*N),M(V*V);for(double&v:p)in>>v;for(double&v:C)in>>v;for(int i=0;i<V;++i)for(int j=0;j<V;++j)M[i*V+j]=C[(((j%P-i%P+P)%P)*N+i/P)*N+j/P];auto m=[&](int i,int j){return M[i*V+j];};auto score=[&](T t){double v=-p[t[3]/P]-p[t[4]/P];for(int i=0;i<3;++i)for(int j=3;j<5;++j)v+=m(t[i],t[j]);for(int i=0;i<3;++i)for(int j=0;j<i;++j)v-=m(t[i],t[j]);return v-m(t[3],t[4]);};auto normalize=[&](T t){T best;best.fill(V);for(int h=0;h<P;++h){T a=t;for(int&v:a)v=(v/P)*P+(v%P+h)%P;std::sort(a.begin(),a.begin()+3);std::sort(a.begin()+3,a.end());best=std::min(best,a);}return best;};std::mt19937_64 rng(20261027);std::set<T>seen;std::vector<std::pair<double,T>>cuts;double max=0;int restarts=0;auto start=std::chrono::steady_clock::now();
for(;restarts<3000;++restarts){if(std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count()>20)break;T t;for(int a=0;a<5;++a){while(true){t[a]=rng()%V;bool ok=true;for(int b=0;b<a;++b)if(t[a]==t[b])ok=false;if(ok)break;}}for(int pass=0;pass<20;++pass){bool changed=false;for(int a=0;a<5;++a){auto contribution=[&](int v){double z=a<3?0:-p[v/P];for(int b=0;b<5;++b)if(b!=a)z+=((a<3)==(b<3)?-1:1)*m(v,t[b]);return z;};double best=contribution(t[a]);int pick=t[a];for(int v=0;v<V;++v){bool ok=true;for(int b=0;b<5;++b)if(b!=a&&t[b]==v)ok=false;if(!ok)continue;double z=contribution(v);if(z>best+1e-12){best=z;pick=v;}}if(pick!=t[a]){changed=true;t[a]=pick;}}if(!changed)break;}double v=score(t);max=std::max(max,v);if(v>1e-5){T c=normalize(t);if(seen.insert(c).second)cuts.push_back({v,c});}}
std::sort(cuts.begin(),cuts.end(),[](auto a,auto b){return a.first>b.first;});std::ofstream out(argv[2]);out<<"{\"maximum_violation\":"<<max<<",\"restarts\":"<<restarts<<",\"cuts\":[";bool comma=false;for(auto[v,t]:cuts){if(comma)out<<",";comma=true;out<<"{\"events\":[";for(int i=0;i<5;++i)out<<(i?",":"")<<t[i];out<<"],\"weights\":[1,1,1,-1,-1],\"constant\":0,\"violation\":"<<v<<"}";}out<<"]}\n";std::cout<<"max "<<max<<" distinct "<<cuts.size()<<" restarts "<<restarts<<"\n";
}
