// Independent implementation from CERT-SPEC.md and SPEC.md only.
#include <algorithm>
#include <array>
#include <bitset>
#include <chrono>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <zlib.h>
using namespace std;
using U=__uint128_t;
using Pair=pair<int,int>;
using Item=vector<Pair>;
using Mat=array<U,128>;
void req(bool b,string s){
    if(!b)throw runtime_error(s);
}
int bit(U x,int k){
    return (x>>k)&1;
} int parity(U x){
    return __builtin_parityll((uint64_t)x)^__builtin_parityll((uint64_t)(x>>64));
}
int top(U x){
    return (x>>64)?127-__builtin_clzll((uint64_t)(x>>64)):63-__builtin_clzll((uint64_t)x);
}
U hex128(string s){
    req(!s.empty()&&s.size()<=32,"bad hex");
    U x=0;
    for(char c:s){
        int v=c>='0'&&c<='9'?c-'0':c>='a'&&c<='f'?c-'a'+10:c>='A'&&c<='F'?c-'A'+10:-1;
        req(v>=0,"bad hex");
        x=x*16+v;
    }return x;
}
vector<U> pool(string p){
    ifstream f(p);
    req(bool(f),"pool open");
    vector<U> v;
    string s;
    while(f>>s)v.push_back(hex128(s));
    return v;
}
// Gaussian elimination in the 128-dimensional binary coordinate space.
vector<U> basis(const vector<U>&v){
    Mat b{
    };
    vector<U> out;
    for(U x:v){
        while(x){
            int k=top(x);
            if(b[k])x^=b[k];
            else{
                b[k]=x;
                out.push_back(x);
                break;
            }
        }
    }return out;
}
struct Lines{
    gzFile f;
    string path;
    uint64_t line=0;
    Lines(string p):path(p){
        f=gzopen(p.c_str(),"rb");
        req(f,"certificate open");
    }~Lines(){
        gzclose(f);
    }string get(){
        char buf[4096];
        req(gzgets(f,buf,sizeof(buf))!=nullptr,"unexpected EOF");
        line++;
        string s(buf);
        req(s.size()&&s.back()=='\n',"unterminated/oversized record");
        s.pop_back();
        if(!s.empty()&&s.back()=='\r')s.pop_back();
        return s;
    }void end(){
        char c;
        int n=gzread(f,&c,1);
        req(n==0,"data after END or gzip failure");
        int err;
        gzerror(f,&err);
        req(err==Z_OK||err==Z_STREAM_END,"gzip error");
    }
};
vector<string> tokens(string s){
    istringstream in(s);
    vector<string> a;
    while(in>>s)a.push_back(s);
    return a;
}
int integer(string s){
    req(!s.empty(),"empty integer");
    long long n=0;
    for(char c:s){
        req(c>='0'&&c<='9',"bad integer");
        n=n*10+c-'0';
        req(n<=1000000000,"integer overflow");
    }return n;
}
struct Checker{
    string cls;
    vector<U>x,z;
    vector<vector<unsigned char>>g;
    vector<Item> items;
    vector<Mat> sums;
    uint64_t nodes=0,ranks=0,empties=0;
    int sd,sh,ns;
    vector<int>chosen;
    vector<Pair>frame;
    bool found=false;
    struct Boundary{
        int c,k;
        vector<int> ids;
        vector<char> types;
        vector<int> live;
    };
    map<vector<int>,Boundary> boundary;
    vector<int> route;
    Pair next(Pair p){
        auto t=[](int i,int k){
            return i/16*16+(i%16+k)%16;
        };
        if(cls=="half")return {
            t(p.first,8),t(p.second,8)
        };
        if(cls=="quarter")return {
            t(p.first,4),t(p.second,4)
        };
        if(cls=="swap")return {
            p.second,p.first
        };
        req(cls=="swapT8","unknown class");
        return {
            t(p.second,8),t(p.first,8)
        };
    }
    bool partial(const Item&a){
        set<int>xx,zz;
        for(auto[i,j]:a){
            if(!xx.insert(i).second||!zz.insert(j).second)return false;
            for(auto[k,l]:a)if(g[i][l]!=(i==k&&j==l))return false;
        }return true;
    }
    void init(string xp,string zp,string ip){
        x=pool(xp);
        z=pool(zp);
        req(x.size()==z.size()&&x.size()%16==0&&x.size()<=1000,"pool dimensions");
        int n=x.size(),ones=0;
        g.assign(n,vector<unsigned char>(n));
        for(int i=0;i<n;i++)for(int j=0;j<n;j++)ones+=(g[i][j]=parity(x[i]&z[j]));
        if(n==720)req(ones==99808,"G sanity");
        set<Item> generated;
        vector<unsigned char>seen(n*n);
        for(int i=0;i<n;i++)for(int j=0;j<n;j++)if(!seen[i*n+j]){
            Item a;
            Pair p={
                i,j
            },start=p;
            do{
                req(p.first>=0&&p.first<n&&p.second>=0&&p.second<n,"orbit range");
                seen[p.first*n+p.second]=1;
                a.push_back(p);
                p=next(p);
                req(a.size()<=4,"orbit closure");
            }while(p!=start);
            sort(a.begin(),a.end());
            if(partial(a))generated.insert(a);
        }
        ifstream f(ip);
        req(bool(f),"instance open");
        int nx,nz,ni,dim;
        req(bool(f>>nx>>nz>>ni>>dim),"instance header");
        req(nx==n&&nz==n&&dim==128&&ni>=0,"instance dimensions");
        string lo,hi;
        req(bool(f>>lo>>hi),"mask");
        req(hex128(lo)==U(UINT64_MAX)&&hex128(hi)==U(UINT64_MAX),"mask mismatch");
        for(auto*v:{
            &x,&z
        })for(U a:*v){
            req(bool(f>>lo>>hi),"instance vector");
            req(lo.size()<=16&&hi.size()<=16&&(hex128(lo)|(hex128(hi)<<64))==a,"instance pool mismatch");
        }
        set<Item>listed;
        for(int q=0;q<ni;q++){
            int k;
            req(bool(f>>k)&&k>=1&&k<=4,"item size");
            Item a;
            for(int h=0;h<k;h++){
                int i,j;
                req(bool(f>>i>>j)&&i>=0&&i<n&&j>=0&&j<n,"item index");
                a.emplace_back(i,j);
            }sort(a.begin(),a.end());
            req(listed.insert(a).second,"duplicate item");
            items.push_back(a);
        }req(!(f>>lo),"trailing instance data");
        req(listed==generated,"item set differs");
        cerr<<"items "<<cls<<" "<<ni<<"; G ones "<<ones<<"\n";
        sums.resize(ni);
        for(int q=0;q<ni;q++)for(auto[i,j]:items[q])for(int c=0;c<128;c++)if(bit(x[i],c))sums[q][c]^=z[j];
    }
    bool compatible(int q,int r){
        for(auto[i,j]:items[q])for(auto[a,b]:items[r])if(i==a||j==b||g[i][b]||g[a][j])return false;
        return true;
    }
    // Basis compression preserves the full live pairing-matrix rank.
    int ranklive(const vector<int>&live, int need){
        vector<U>xx,zz;
        bitset<1024>sx,sz;
        for(int q:live)for(auto[i,j]:items[q]){
            if(!sx[i]){
                sx[i]=1;
                xx.push_back(x[i]);
            }if(!sz[j]){
                sz[j]=1;
                zz.push_back(z[j]);
            }
        }
        int bound=min(xx.size(),zz.size());
        if(bound<need)return bound;
        auto bx=basis(xx);
        if((int)bx.size()<need)return bx.size();
        auto bz=basis(zz);
        if((int)bz.size()<need)return bz.size();
        vector<U>rows;
        for(U a:bx){
            U r=0;
            for(size_t j=0;j<bz.size();j++)if(parity(a&bz[j]))r|=U(1)<<j;
            rows.push_back(r);
        }return basis(rows).size();
    }
    void verifyframe(){
        Item a;
        for(int q:chosen)a.insert(a.end(),items[q].begin(),items[q].end());
        req(a.size()==128&&partial(a),"invalid frame");
        set<Pair>s(a.begin(),a.end());
        for(auto p:a)req(s.count(next(p)),"frame not invariant");
        Mat m{
        };
        for(int q:chosen)for(int c=0;c<128;c++)m[c]^=sums[q][c];
        for(int c=0;c<128;c++)req(m[c]==(U(1)<<c),"frame identity failure");
        frame=a;
        found=true;
    }
    // The certificate contributes syntax only; all semantic state is derived here.
    void node(Lines&in,int need,const Mat&res,const vector<int>&live,int depth){
        req(depth<=128&&need>=0,"invalid depth/need");
        nodes++;
        if(nodes%1000000==0)cerr<<cls<<" shard "<<sh<<" checked "<<nodes<<" nodes\n";
        auto a=tokens(in.get());
        if(need==0){
            verifyframe();
            throw string("FRAME");
        }req(!a.empty(),"empty record");
        if(a[0]=="R"){
            req(a.size()==1,"R arity");
            ranks++;
            req(ranklive(live,need)<need,"invalid rank leaf");
            return;
        }req(a[0]!="F","F without verified complete frame");
        req(a[0]=="E"||a[0]=="B","unknown node");
        bool branch=a[0]=="B";
        req(a.size()==(branch?4:3),"node arity");
        int c=integer(a[1]),k=integer(a[2]);
        req(c<128&&k<128&&bit(res[c],k),"branch/empty residual entry");
        vector<int>cov;
        for(int q:live)if(bit(sums[q][c],k))cov.push_back(q);
        if(!branch){
            empties++;
            req(cov.empty(),"nonempty E cover");
            return;
        }int m=integer(a[3]);
        req(m==(int)cov.size(),"B cover size");
        set<int>todo(cov.begin(),cov.end()),done;
        Boundary b{
            c,k,{
            },{
            },depth==sd?live:vector<int>{
            }
        };
        for(int h=0;h<m;h++){
            auto ch=tokens(in.get());
            req(ch.size()==2&&(ch[0]=="C"||ch[0]=="K"||ch[0]=="S"),"child record");
            int q=integer(ch[1]);
            req(todo.erase(q)==1,"child not in cover or repeated");
            char ty=ch[0][0];
            if(depth==sd){
                b.ids.push_back(q);
                b.types.push_back(ty);
            }if(ty=='S')req(ns>1&&depth==sd,"S outside shard boundary");
            if(ty=='K')req(items[q].size()>(size_t)need,"invalid K");
            if(ty=='C'){
                req(items[q].size()<=(size_t)need,"oversized C");
                vector<int>child;
                for(int r:live)if(r!=q&&!done.count(r)&&compatible(q,r))child.push_back(r);
                Mat rr=res;
                for(int v=0;v<128;v++)rr[v]^=sums[q][v];
                chosen.push_back(q);
                route.push_back(q);
                node(in,need-items[q].size(),rr,child,depth+1);
                route.pop_back();
                chosen.pop_back();
            }done.insert(q);
        }
        if(depth==sd)req(boundary.emplace(route,move(b)).second,"duplicate boundary path");
    }
    void run(string path){
        Lines in(path);
        auto a=tokens(in.get());
        req(a.size()==14&&a[0]=="C16CERT"&&a[1]=="1"&&a[2]=="need"&&a[3]=="128"&&a[4]=="items"&&integer(a[5])==(int)items.size()&&a[6]=="live_sides"&&a[7]=="1"&&a[8]=="shard"&&a[10]=="nshard"&&a[12]=="shard_depth","header");
        sh=integer(a[9]);
        ns=integer(a[11]);
        sd=integer(a[13]);
        req(ns>0&&sh<ns&&sd<=128,"shard metadata");
        Mat r{
        };
        for(int c=0;c<128;c++)r[c]=U(1)<<c;
        vector<int>live;
        for(size_t q=0;q<items.size();q++)live.push_back(q);
        node(in,128,r,live,0);
        req(in.get()=="END COMPLETE","missing END COMPLETE");
        in.end();
    }
};
string esc(string s){
    string o="\"";
    for(char c:s){
        if(c=='"'||c=='\\')o+='\\';
        if(c=='\n'){
            o+="\\n";
            continue;
        }o+=c;
    }return o+'"';
}
int main(int argc,char**argv){
    if(argc<6){
        cerr<<"usage: check CLASS XPOOL ZPOOL INSTANCE CERT...\n";
        return 2;
    }auto start=chrono::steady_clock::now();
    Checker c;
    string result="REJECT",note;
    vector<map<vector<int>,Checker::Boundary>> boundaries;
    set<int>shards;
    int ns=-1,sd=-1;
    try{
        c.cls=argv[1];
        c.init(argv[2],argv[3],argv[4]);
        for(int i=5;i<argc;i++){
            c.boundary.clear();
            c.run(argv[i]);
            if(ns<0){
                ns=c.ns;
                sd=c.sd;
            }req(ns==c.ns&&sd==c.sd&&shards.insert(c.sh).second,"inconsistent/duplicate shards");
            boundaries.push_back(c.boundary);
        }req((int)shards.size()==ns,"missing shard files");
        if(ns>1){
            auto&base=boundaries[0];
            for(auto&b:boundaries)req(b.size()==base.size(),"boundary set mismatch");
            for(auto&[path,b]:base){
                vector<int>owners(b.ids.size());
                for(auto&other:boundaries){
                    auto it=other.find(path);
                    req(it!=other.end(),"missing boundary path");
                    auto&v=it->second;
                    req(v.c==b.c&&v.k==b.k&&v.ids==b.ids&&v.live==b.live,"boundary mismatch");
                    for(size_t j=0;j<v.ids.size();j++)owners[j]+=v.types[j]!='S';
                }for(int n:owners)req(n==1,"shard coverage ownership");
            }
        }result="ACCEPT";
        note="all instance, tree, and shard checks passed";
    }catch(string&s){
        result=s;
        note="verified 128 distinct X/Z indices, identity pairing, symmetry and outer-product identity";
    }catch(exception&e){
        note=e.what();
    }
    double sec=chrono::duration<double>(chrono::steady_clock::now()-start).count();
    cout<<"{\"class\":"<<esc(argv[1])<<",\"files\":[";
    for(int i=5;i<argc;i++){
        if(i>5)cout<<',';
        cout<<esc(argv[i]);
    }cout<<"],\"result\":"<<esc(result)<<",\"nodes\":"<<c.nodes<<",\"rank_leaves\":"<<c.ranks<<",\"empty_leaves\":"<<c.empties<<",\"seconds\":"<<sec<<",\"notes\":"<<esc(note)<<",\"items\":"<<c.items.size();
    if(c.found){
        cout<<",\"frame\":[";
        bool first=true;
        for(auto[i,j]:c.frame){
            if(!first)cout<<',';
            first=false;
            cout<<'['<<i<<','<<j<<']';
        }cout<<']';
    }cout<<"}\n";
    return result=="REJECT"?1:0;
}
