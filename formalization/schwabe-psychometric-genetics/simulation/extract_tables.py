"""Extract numerical simulation targets from the local layout text; validate sizes."""
import re,csv,sys
text=open(sys.argv[1]).read();rows=[]
def parse(section,table,parameters,expected):
 lines=section.splitlines();count=0
 for i,line in enumerate(lines):
  m=re.match(r'\s*(N|Ni)\s*=\s*(\d+)\s+(.+)',line)
  if not m:continue
  values=re.findall(r'(-?\d+\.\d+)\s*\((-?\d+\.\d+)\)',m[3]);sd=re.findall(r'-?\d+\.\d+',lines[i+1]);assert len(values)==len(sd)==expected,(table,m[2],values,sd)
  for j,((mean,rep_sd),post_sd) in enumerate(zip(values,sd)):
   delta=[1,1.3,1.5,1.7][j//4] if table=='2.3' else ''
   rows.append(dict(table=table,N=int(m[2])if m[1]=='N' else 1000,J=int(m[2])if m[1]=='Ni' else 60,delta=delta,parameter=parameters[j%len(parameters)],mean=float(mean),replicate_sd=float(rep_sd),posterior_sd=float(post_sd),replicates=100 if table=='2.3' else 250,precision='.01'))
  count+=1
 return count
s=text.split('Table 2.3:')[1].split('2.8    Discussion')[0];assert parse(s,'2.3',['A','C','E','beta1'],16)==3
s=text.split('Table 5.1:')[1].split('Part II:')[0];assert parse(s,'5.1',['main','A','C','E','beta1a','beta1c','beta1e'],7)==4
s=text.split('Table 5.2:')[1].split('It can be seen')[0];assert parse(s,'5.2',['main','A','C','E','beta1a','beta1c','beta1e'],7)==3
with open('outputs/source-simulation-targets.csv','w')as f:w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
with open('outputs/source-power-targets.csv','w')as f:
 w=csv.writer(f);w.writerow(['N','delta','power','replicates','locator'])
 for N,powers in zip([500,1000,2000],[[.03,.48,.57,.81],[.07,.57,.92,.99],[.07,.92,1,1]]):
  for d,p in zip([1,1.3,1.5,1.7],powers):w.writerow([N,d,p,100,'Table2.2 p22'])
