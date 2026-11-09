#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;

// Compress observations by cluster and follow-up length. Within a length,
// X=[1,time] is shared; retain X'y and its outer products, and y'y.
// [[Rcpp::export]]
NumericMatrix reml_statistics(IntegerVector sizes, IntegerVector cluster,
                              NumericVector y, int J) {
    NumericMatrix s(4*J,7);
    int pos=0;
    for (int i=0;i<sizes.size();++i) {
        int k=sizes[i], r=4*(cluster[i]-1)+k-1;
        double a=0,b=0,c=0;
        for (int t=0;t<k;++t) {double v=y[pos++]; a+=v;b+=t*v;c+=v*v;}
        s(r,0)++;s(r,1)+=a;s(r,2)+=b;s(r,3)+=c;
        s(r,4)+=a*a;s(r,5)+=a*b;s(r,6)+=b*b;
    }
    if(pos!=y.size()) stop("observation counts do not add up");
    return s;
}

// Matrix determinant lemma and Woodbury for two random coefficients.
// g00,g01,g11 describe the input information matrix G, u/v variances.
// Return T(I+GT)^-1, valid even if either variance is zero.
static inline void adjust(double g00,double g01,double g11,double u,double v,
                          double &ld,double &l00,double &l01,double &l11) {
    const double det=(1+g00*u)*(1+g11*v)-g01*g01*u*v;
    ld=std::log(det);
    l00=u*(1+g11*v)/det;l01=-u*v*g01/det;l11=v*(1+g00*u)/det;
}

struct Information {double a=0,b=0,c=0,y=0,z=0;};
struct Update {
    double a,b,c,d00,d01,d10,d11,l00,l01,l11,ld;
    Update(double g00,double g01,double g11,double u,double v) {
        adjust(g00,g01,g11,u,v,ld,l00,l01,l11);
        d00=1-g00*l00-g01*l01;d01=-g00*l01-g01*l11;
        d10=-g01*l00-g11*l01;d11=1-g01*l01-g11*l11;
        a=d00*g00+d01*g01;b=d00*g01+d01*g11;c=d10*g01+d11*g11;
    }
};

// Fit using arm-specific fixed intercepts/slopes, a full-rank reparameterization
// of the source model. Profile out residual variance; minimize twice the
// negative REML log likelihood up to a parameter-independent constant.
// [[Rcpp::export]]
NumericVector reml_eval(NumericVector theta, NumericMatrix s, int control, bool details=false) {
    Update k[]={{1,0,0,theta[0],theta[1]}, {2,1,1,theta[0],theta[1]},
                {3,3,5,theta[0],theta[1]}, {4,6,14,theta[0],theta[1]}};
    double logdet=0,rss=0,n=0;
    Information arm[2];
    for(int j=0;j<s.nrow()/4;++j) {
        Information g;
        for(int q=0;q<4;++q) {
            const int r=4*j+q; const auto &v=k[q]; const double m=s(r,0);
            if(m==0) continue;
            n+=m*(q+1);logdet+=m*v.ld;
            g.a+=m*v.a;g.b+=m*v.b;g.c+=m*v.c;
            g.y+=v.d00*s(r,1)+v.d01*s(r,2);
            g.z+=v.d10*s(r,1)+v.d11*s(r,2);
            rss+=s(r,3)-v.l00*s(r,4)-2*v.l01*s(r,5)-v.l11*s(r,6);
        }
        const Update v(g.a,g.b,g.c,theta[2],theta[3]);
        auto &t=arm[j>=control];
        t.a+=v.a;t.b+=v.b;t.c+=v.c;t.y+=v.d00*g.y+v.d01*g.z;t.z+=v.d10*g.y+v.d11*g.z;
        logdet+=v.ld;
        rss-=v.l00*g.y*g.y+2*v.l01*g.y*g.z+v.l11*g.z*g.z;
    }
    double slope[2], ivar=0;
    for(int j=0;j<2;++j) {
        const auto &t=arm[j]; const double det=t.a*t.c-t.b*t.b;
        const double intercept=(t.c*t.y-t.b*t.z)/det;
        slope[j]=(t.a*t.z-t.b*t.y)/det;
        rss-=intercept*t.y+slope[j]*t.z;
        logdet+=std::log(det);
        ivar+=t.a/det;
    }
    double scale=rss/(n-4), objective=logdet+(n-4)*std::log(scale);
    if(!details) return NumericVector::create(objective);
    return NumericVector::create(_["objective"]=objective, _["beta"]=slope[1]-slope[0],
        _["se"]=std::sqrt(ivar*scale), _["person_intercept"]=theta[0]*scale,
        _["person_slope"]=theta[1]*scale,_["cluster_intercept"]=theta[2]*scale,
        _["cluster_slope"]=theta[3]*scale,_["residual"]=scale);
}
