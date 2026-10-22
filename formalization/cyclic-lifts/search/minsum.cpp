// Flooding syndrome normalized min-sum, perfect syndrome, binary prior.
// Equations: Raveendran et al., EPJ Quantum Technology 10, 45 (2023),
// Section 2.4, Eqs. (2)-(4); scalar normalization alpha, saturation +/-50.
// Input and output formats are exercised by benchmark_decoding.py.
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct Tanner {
  int n, m;
  std::vector<std::vector<int>> ce, ve;
  std::vector<int> variable;
  Tanner(int nv, int nc): n(nv), m(nc), ce(nc), ve(nv) {}
  void edge(int c, int v) {
    int e = variable.size();
    variable.push_back(v); ce[c].push_back(e); ve[v].push_back(e);
  }
  std::vector<int> syndrome(const std::string &x) const {
    std::vector<int> s(m, 0);
    for (int c=0; c<m; ++c)
      for (int e: ce[c]) s[c] ^= (x[variable[e]]=='1');
    return s;
  }
};

// Exact integer message arithmetic prevents platform-dependent decisions
// at zero caused by cancellation of floating-point extrinsic messages.
constexpr int64_t scale = 1LL << 20;
int64_t clip(int64_t x) { return std::max(-50*scale, std::min(50*scale,x)); }

struct Result { std::string estimate; int iterations; bool matched; };

Result decode(const Tanner &h, const std::vector<int> &s, double p,
              int max_iter, double alpha) {
  const int ne = h.variable.size();
  const int64_t prior = std::llround(std::log((1-p)/p)*scale);
  const int64_t alpha_thousandths = std::llround(alpha*1000);
  std::vector<int64_t> q(ne, clip(prior)), message(ne, 0);
  std::string estimate(h.n, '0');
  if (h.syndrome(estimate)==s) return {estimate,0,true};
  for (int it=1; it<=max_iter; ++it) {
    for (int c=0; c<h.m; ++c) {
      int64_t least=1000*scale, second=1000*scale;
      int minimum_edge=-1, sign=s[c] ? -1 : 1;
      for (int e: h.ce[c]) {
        const int64_t a=std::abs(q[e]);
        if (q[e]<0) sign=-sign;
        if (a<least) {second=least;least=a;minimum_edge=e;}
        else if (a<second) second=a;
      }
      for (int e: h.ce[c])
        message[e]=clip(sign * (q[e]<0 ? -1 : 1) *
                        ((alpha_thousandths*(e==minimum_edge ? second : least)+500)/1000));
    }
    for (int v=0; v<h.n; ++v) {
      int64_t posterior=prior;
      for (int e: h.ve[v]) posterior+=message[e];
      estimate[v]=(posterior<0 ? '1' : '0');
      for (int e: h.ve[v]) q[e]=clip(posterior-message[e]);
    }
    if (h.syndrome(estimate)==s) return {estimate,it,true};
  }
  return {estimate,max_iter,false};
}

int main() {
  std::ios::sync_with_stdio(false);
  std::cin.tie(nullptr);
  int n,m,trials,max_iter;
  double alpha;
  if (!(std::cin>>n>>m>>trials>>max_iter>>alpha)) return 1;
  if (n<=0 || m<=0 || trials<0 || max_iter<=0 || alpha<=0 || alpha>1) return 2;
  Tanner h(n,m);
  for (int c=0; c<m; ++c) {
    int degree; std::cin>>degree;
    if (degree<2) return 3;
    for (int j=0; j<degree; ++j) {
      int v; std::cin>>v;
      if (v<0 || v>=n) return 4;
      h.edge(c,v);
    }
  }
  for (int t=0; t<trials; ++t) {
    double p; std::string error;
    std::cin>>p>>error;
    if (p<=0 || p>=0.5 || (int)error.size()!=n ||
        error.find_first_not_of("01")!=std::string::npos) return 5;
    Result r=decode(h,h.syndrome(error),p,max_iter,alpha);
    std::cout<<r.iterations<<' '<<r.matched<<' '<<r.estimate<<'\n';
  }
  return std::cin.fail() ? 6 : 0;
}
