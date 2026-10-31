// Bounded coordinate ascent for universal L(L-1)/2 >= 0 proposals.
// This is a heuristic proposal generator, never an exhaustive separation proof.
#include <algorithm>
#include <chrono>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <random>
#include <set>
#include <sstream>
#include <stdexcept>
#include <vector>

int main(int argc, char** argv) {
  if (argc != 8) throw std::runtime_error("input output weights restarts seconds seed constant");
  std::ifstream in(argv[1]); int N, P; in >> N >> P;
  if (!in || N != 90 || P != 16) throw std::runtime_error("Unexpected physical input layout");
  const int V = N * P;
  std::vector<double> p(N), C(P*N*N), M(V*V);
  for (double& v : p) in >> v;
  for (double& v : C) in >> v;
  if (!in) throw std::runtime_error("Incomplete moments");
  for (int i=0; i<V; ++i) for (int j=0; j<V; ++j)
    M[i*V+j] = C[(((j%P-i%P+P)%P)*N+i/P)*N+j/P];
  std::vector<int> w; std::stringstream ws(argv[3]); std::string token;
  while (std::getline(ws, token, ',')) w.push_back(std::stoi(token));
  const int K = w.size(), limit = std::stoi(argv[4]), constant = std::stoi(argv[7]);
  const double seconds = std::stod(argv[5]);
  if (K<1 || K>12 || limit<1 || !(seconds>0)) throw std::runtime_error("Bad limits");
  std::mt19937_64 rng(std::stoull(argv[6]));
  auto m = [&](int i,int j) { return M[i*V+j]; };
  auto score = [&](const std::vector<int>& t) {
    double s = -constant*(constant-1)/2.0;
    for (int i=0;i<K;++i) {
      s -= (constant*w[i]+w[i]*(w[i]-1)/2.0)*p[t[i]/P];
      for (int j=0;j<i;++j) s -= w[i]*w[j]*m(t[i],t[j]);
    }
    return s;
  };
  auto normalize = [&](const std::vector<int>& t) {
    std::vector<int> best(K,V);
    for (int swap=0;swap<2;++swap) for (int h=0;h<P;++h) {
      std::vector<int> a=t;
      for (int& v:a) v=(((v/P)^0)+45*swap)%90*P+(v%P+h)%P;
      for (int q=-4;q<=4;++q) {
        std::vector<int> slots, values;
        for (int i=0;i<K;++i) if (w[i]==q) {slots.push_back(i);values.push_back(a[i]);}
        std::sort(values.begin(),values.end());
        for (size_t i=0;i<slots.size();++i) a[slots[i]]=values[i];
      }
      best=std::min(best,a);
    }
    return best;
  };
  std::set<std::vector<int>> seen;
  std::vector<std::pair<double,std::vector<int>>> cuts;
  auto start=std::chrono::steady_clock::now();
  auto elapsed=[&]() {return std::chrono::duration<double>(std::chrono::steady_clock::now()-start).count();};
  double bestscore=-1e100; int restarts=0, moves=0;
  for (;restarts<limit && elapsed()<seconds;++restarts) {
    std::vector<int> t(K);
    for (int i=0;i<K;++i) do {t[i]=rng()%V;} while (std::find(t.begin(),t.begin()+i,t[i])!=t.begin()+i);
    for (int pass=0;pass<40;++pass) {
      bool changed=false;
      for (int a=0;a<K;++a) {
        auto contribution=[&](int v) {
          double s=-(constant*w[a]+w[a]*(w[a]-1)/2.0)*p[v/P];
          for (int b=0;b<K;++b) if (a!=b) s-=w[a]*w[b]*m(v,t[b]);
          return s;
        };
        double best=contribution(t[a]); int pick=t[a];
        for (int v=0;v<V;++v) {
          bool duplicate=false;
          for (int b=0;b<K;++b) if (a!=b && t[b]==v) {duplicate=true;break;}
          if (duplicate) continue;
          const double z=contribution(v);
          if (z>best+1e-12) {best=z;pick=v;}
        }
        if (pick!=t[a]) {t[a]=pick;changed=true;++moves;}
      }
      if (!changed || elapsed()>=seconds) break;
    }
    double s=score(t); bestscore=std::max(bestscore,s);
    if (s>1e-8) {
      auto n=normalize(t);
      if (std::abs(s-score(n))>1e-10) throw std::runtime_error("Symmetry score disagreement");
      if (seen.insert(n).second) cuts.push_back({s,n});
    }
  }
  std::sort(cuts.begin(),cuts.end(),[](const auto& a,const auto& b){return a.first>b.first;});
  std::ofstream out(argv[2]); out << std::setprecision(17);
  out << "{\"status\":\"HEURISTIC_INTEGER_FORM_PROPOSALS\",\"maximum_violation\":" << bestscore
      << ",\"restarts\":" << restarts << ",\"moves\":" << moves << ",\"seconds\":" << elapsed() << ",\"cuts\":[";
  bool comma=false;
  for (const auto& item:cuts) {
    if (comma) out << ','; comma=true;
    out << "{\"events\":[";
    for (int i=0;i<K;++i) out << (i?",":"") << item.second[i];
    out << "],\"weights\":[";
    for (int i=0;i<K;++i) out << (i?",":"") << w[i];
    out << "],\"constant\":" << constant << ",\"violation\":" << item.first << '}';
  }
  out << "]}\n";
  std::cout << "restarts " << restarts << " proposals " << cuts.size() << " best " << bestscore << " seconds " << elapsed() << '\n';
}
