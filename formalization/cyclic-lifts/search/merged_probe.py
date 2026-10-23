"""Read-only original-source state probes for independent witness checks."""
from pathlib import Path
import json,subprocess
HERE=Path(__file__).resolve().parent


def compile_probe(destination):
    source=(HERE/'minsum.cpp').read_text()
    before='for (int it=1; it<=max_iter; ++it) {';after='if (h.syndrome(estimate)==s) return {estimate,it,true};'
    assert source.count(before)==source.count(after)==1
    source=source.replace(before,before+'\n    save_input(q);').replace(after,'save_output(message,estimate);\n    '+after)
    prelude='''#include <vector>
#include <string>
#include <cstdint>
struct Snapshot {std::vector<int64_t> q,r;std::string estimate;};
std::vector<Snapshot>* active_states=nullptr;
std::vector<int64_t> current_input;
void save_input(const std::vector<int64_t>&q){if(active_states)current_input=q;}
void save_output(const std::vector<int64_t>&r,const std::string&x){if(active_states)active_states->push_back({current_input,r,x});}
#define main archived_single_main
'''
    path=Path(destination).with_suffix('.cpp');path.write_text(prelude+source+'\n#undef main\n'+(HERE/'merged_state_probe.cpp').read_text())
    subprocess.run(['c++','-std=c++17','-O3',str(path),'-o',str(destination)],check=True)


def probe(binary,rows,error,steps):
    data=[f'252 {len(rows)} .04 {len(steps)}',' '.join(map(str,steps))]
    data.extend(str(len(row))+' '+' '.join(map(str,row)) for row in rows);data.append(error)
    return json.loads(subprocess.run([str(binary)],input='\n'.join(data)+'\n',text=True,capture_output=True,check=True).stdout)
