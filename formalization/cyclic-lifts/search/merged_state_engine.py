"""Read-only state instrumentation of the frozen decoder source."""
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent


def compile_engine(destination):
    source=(HERE/'minsum.cpp').read_text()
    before='for (int it=1; it<=max_iter; ++it) {'
    after='if (h.syndrome(estimate)==s) return {estimate,it,true};'
    assert source.count(before)==source.count(after)==1
    source=source.replace(before,before+'\n    save_input(q);')
    source=source.replace(after,'save_output(message,estimate);\n    '+after)
    prefix='''#include <vector>
#include <string>
#include <cstdint>
struct Snapshot {std::vector<int64_t> q,r;std::string estimate;};
std::vector<Snapshot>* active_states=nullptr;
std::vector<int64_t> current_input;
void save_input(const std::vector<int64_t>&q){if(active_states)current_input=q;}
void save_output(const std::vector<int64_t>&r,const std::string&x){if(active_states)active_states->push_back({current_input,r,x});}
#define main archived_single_main
'''
    cpp=Path(destination).with_suffix('.cpp')
    cpp.write_text(prefix+source+'\n#undef main\n'+(HERE/'merged_mechanism.cpp').read_text())
    subprocess.run(['c++','-std=c++17','-O3',str(cpp),'-o',str(destination)],check=True)


def data(original,merged,pair,trials):
    lines=[f'252 126 125 {len(trials)} 100 0.8 {pair[0]} {pair[1]}']
    for rows in [original,merged]:lines.extend(str(len(row))+' '+' '.join(map(str,row)) for row in rows)
    lines.extend(f'{index} .04 {error}' for index,error in trials)
    return '\n'.join(lines)+'\n'
