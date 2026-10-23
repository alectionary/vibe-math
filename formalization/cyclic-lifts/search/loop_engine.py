"""Read-only full-state hooks; decoder update equations are included unchanged."""
from pathlib import Path
import subprocess,json
HERE=Path(__file__).resolve().parent

def compile_engine(destination):
 source=(HERE/'minsum.cpp').read_text()
 marker='for (int it=1; it<=max_iter; ++it) {'
 assert source.count(marker)==1
 source=source.replace(marker,marker+'\n    observe_input(q,it);')
 marker='if (h.syndrome(estimate)==s) return {estimate,it,true};'
 assert source.count(marker)==1
 source=source.replace(marker,'observe_output(estimate);\n    '+marker)
 pre='''#include <vector>
#include <string>
#include <cstdint>
std::vector<std::vector<int64_t>>* active_q=nullptr;
std::vector<std::string>* active_x=nullptr;
void observe_input(const std::vector<int64_t>&q,int){if(active_q)active_q->push_back(q);}
void observe_output(const std::string&x){if(active_x)active_x->push_back(x);}
#define main archived_main
'''
 path=Path(destination).with_suffix('.cpp');path.write_text(pre+source+'\n#undef main\n'+(HERE/'loop_mechanisms.cpp').read_text())
 subprocess.run(['c++','-std=c++17','-O3',str(path),'-o',str(destination)],check=True)

def run_engine(binary,rows,errors,detail=False,profile=1):
 data=[f'252 {len(rows)} {len(errors)} {int(detail)} {profile}']
 data.extend(str(len(row))+' '+' '.join(map(str,row)) for row in rows)
 data.extend(f'{index} {error}' for index,error in errors)
 p=subprocess.run([str(binary)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True)
 assert not p.stderr
 out=[json.loads(line) for line in p.stdout.splitlines()];assert len(out)==len(errors)
 return out
