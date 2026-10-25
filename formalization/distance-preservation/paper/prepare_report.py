"""Generate the local proof guide, exact declaration audit and source snapshot.

No proof sources or frozen investigation records are modified. Run after a PDF
build; validate_report.py independently checks the archive, links and coverage.
"""
from pathlib import Path
import ast, datetime, hashlib, html, json, os, re, subprocess, sys, zipfile

P = Path(__file__).resolve().parent
W = P.parent
R = W.parent.parent

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def dump(p, x):
    p.write_text(json.dumps(x, indent=2, ensure_ascii=False) + '\n')

def main():
    source = (P/'main.tex').read_text()
    manuscript_files=['main.tex','lean-appendix.tex','listing-inputs.tex',
                      'proof-targets.tex','proof-file-index.tex']
    manuscript_files+=['listings/'+f.name for f in sorted((P/'listings').glob('*.tex'))]
    all_source='\n'.join((P/f).read_text() for f in manuscript_files)
    appendix=json.loads((P/'appendix-listings.json').read_text())
    # Read the frozen module list without importing/rerunning its auditor.
    tree = ast.parse((W/'audit_artifact.py').read_text())
    node = next(n.value for n in tree.body if isinstance(n, ast.Assign)
                and any(isinstance(t,ast.Name) and t.id=='MODULES' for t in n.targets))
    modules = ast.literal_eval(node.func.value).split()
    assert len(modules)==50
    frozen = json.loads((W/'clean-rebuild.json').read_text())
    assert frozen['status']=='PASS'
    for mod in modules:
        assert sha(W/(mod+'.lean')) == frozen['source_sha256'][mod], mod
        rec=json.loads((W/'logs'/(mod+'.json')).read_text())
        assert rec['source_sha256']==sha(W/(mod+'.lean')) and rec['exit_code']==0
        assert rec['log_sha256']==sha(W/'logs'/(mod+'.log'))

    refs=sorted(set(re.findall(r'\\lean\{([^}]+)\}\{([^}]+)\}',all_source)))
    for mod, name in refs:
        assert mod in modules, mod
        assert re.search(r'\b(?:theorem|lemma|def|abbrev)\s+'+re.escape(name.split('.')[-1])+r'\b',
                         (W/(mod+'.lean')).read_text()), (mod,name)
    proofs=[]
    for n,m in enumerate(re.finditer(r'\\begin\{proof\}(?:\[[^]]*\])?(.*?)\\end\{proof\}', source, re.S),1):
        names=re.findall(r'\\lean\{([^}]+)\}\{([^}]+)\}',m[1])
        assert names, ('Missing proof links',n)
        previous=re.findall(r'\\label\{([^}]+)\}',source[:m.start()])[-1]
        if 'Proof of Theorem' in m[0]: previous='thm:main'
        proofs.append({'proof_number':n,'manuscript_label':previous,
                       'formal_results':[{'module':a,'declaration':b} for a,b in names]})
    expected={'prop:bridges','thm:template','lem:cover','lem:base','cor:lower',
              'cor:param','prop:upper','prop:transpose','prop:graph','thm:main'}
    assert {x['manuscript_label'] for x in proofs}==expected
    # The separately explained two-fiber application is also in the table.
    coverage={'manuscript_sha256':sha(P/'main.tex'),'proof_environments':proofs,
              'additional_application':{'name':'Two-fiber classical word and transpose comparison',
                'declarations':['DistanceFamily.classical_distance_upper',
                                'DistanceFamily.stronger_counterfamily']},
              'linked_declarations':[{'module':a,'declaration':b} for a,b in refs],
              'appendix_lean_listings':appendix['listings'],
              'manuscript_files_sha256':{f:sha(P/f) for f in manuscript_files},
              'scope':'Every manuscript proof, explicitly proved application and complete displayed Lean declaration; exploratory routes remain outside proved results.'}
    dump(P/'proof-coverage.json',coverage)

    audit='import FinalAudit\n\n-- Audit every declaration linked in the manuscript.\n'
    for _, name in refs:
        audit+=f'#check {name}\n#print axioms {name}\n'
    (P/'PaperAudit.lean').write_text(audit)
    runtime=json.loads((W/'.lean-runtime.json').read_text())
    paths=[x for x in runtime['LEAN_PATH'].split(':')
           if 'dyadic-rank/.lake/build' not in x]
    env=dict(os.environ,LEAN_PATH=':'.join([frozen['scratch_path']]+paths))
    prior=json.loads((P/'paper-lean-audit.json').read_text()) if (P/'paper-lean-audit.json').exists() else {}
    reuse=(prior.get('status')=='PASS' and prior.get('source_sha256')==sha(P/'PaperAudit.lean')
           and (P/'PaperAudit.log').exists() and prior.get('log_sha256')==sha(P/'PaperAudit.log')
           and prior.get('isolated_source_set_sha256')==frozen['source_set_sha256'])
    if not reuse:
        start=datetime.datetime.now(datetime.timezone.utc)
        result=subprocess.run([runtime['lean'],'-M','6000',str(P/'PaperAudit.lean')],
                              cwd=P,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        (P/'PaperAudit.log').write_text(result.stdout)
        assert result.returncode==0, result.stdout
        dump(P/'paper-lean-audit.json',{'status':'PASS','started_utc':start.isoformat(),
            'finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'declarations':len(refs),'source_sha256':sha(P/'PaperAudit.lean'),
            'log_sha256':sha(P/'PaperAudit.log'),'isolated_source_set_sha256':frozen['source_set_sha256'],
            'research_objects_excluded':True,'allowed_axioms':['Classical.choice','Quot.sound','propext']})
    body=(P/'PaperAudit.log').read_text()
    assert not any(x in body for x in ['sorryAx','_native.','error:'])
    allowed={'propext','Quot.sound','Classical.choice'}
    for group in re.findall(r'depends on axioms: \[([^]]*)\]',body):
        assert set(x.strip() for x in group.split(',') if x.strip())<=allowed
    for _,name in refs:
        assert ("'"+name+"' depends on axioms:" in body or
                "'"+name+"' does not depend on any axioms" in body), name

    heading='''<!doctype html><html lang="en"><meta charset="utf-8">
<title>Distance-preservation proof guide</title>
<style>body{max-width:1100px;margin:3em auto;padding:0 2em;font:16px/1.5 system-ui}
table{border-collapse:collapse;width:100%}td,th{padding:.6em;text-align:left;vertical-align:top;border-bottom:1px solid #ddd}
code,pre{font-size:13px}pre{overflow:auto;background:#f4f4f4;padding:1em}code{overflow-wrap:anywhere}
a{color:#135eac}h2{margin-top:2em}</style>
<h1>Distance loss in girth-eight cyclic lifted-product codes</h1>
<p><a href="main.pdf">Manuscript PDF</a> · <a href="main.tex">TeX source</a> ·
<a href="proof-coverage.json">Proof coverage</a> · <a href="paper-lean-audit.json">Declaration audit</a></p>
<p>The fifty mathematical proof sources are published at immutable commit
<a href="https://github.com/alectionary/vibe-math/tree/98eb91cd9049e6a88887a5ba79150ad96a4a3e53/formalization/distance-preservation">98eb91cd9049e6a88887a5ba79150ad96a4a3e53</a>.
The manuscript's Lean appendices give complete central proof bodies and declaration-level
links into that snapshot. This presentation build and its source archive are local
until separately committed; the pinned mathematical sources are unchanged.</p>
<p>Lean 4.36.0-rc1; mathlib
<code>5f7b4198d22a9c82e1c698a379334fe128095c82</code>.
All fifty admitted modules passed source-bound and isolated authored-source builds.
Cached pinned mathlib/dependencies/std were reused. Only propext, Classical.choice
and Quot.sound occur in the audited closure. External search exclusions are not premises.</p>
<h2>Manuscript proofs</h2><table><tr><th>Manuscript label</th><th>Complete formal counterparts</th></tr>'''
    out=heading
    for proof in proofs:
        links=[]
        for ref in proof['formal_results']:
            links.append(f'<a href="../{ref["module"]}.lean"><code>{html.escape(ref["declaration"])}</code></a>')
        out+=f'<tr><td>{html.escape(proof["manuscript_label"])}</td><td>'+ '<br>'.join(links)+'</td></tr>\n'
    out+='</table><p>The two-fiber application is covered by <a href="../FamilyBounds.lean">FamilyBounds.lean</a> (classical_distance_upper and stronger_counterfamily).</p>'
    out+='<h2>Meaningful source statements and proof excerpts</h2>'
    for mod,key in [('SourceWordBridge','theorem source_distance_drop'),
                    ('CoverDistance','theorem lower_bound'),
                    ('ParametricSource','theorem source_parametric_obstruction'),
                    ('TransposeDistance','theorem distance_characterization')]:
        body=(W/(mod+'.lean')).read_text();a=body.index(key)
        b=body.find('\n#print axioms',a)
        if b<0:b=body.find('\nend ',a)
        out+=f'<h3><a href="../{mod}.lean">{mod}.lean</a></h3><pre>'+html.escape(body[a:b])+'</pre>'
    out+='<h2>Complete admitted source closure</h2><table><tr><th>Module / checked records</th><th>SHA-256</th><th>Imports</th></tr>'
    for mod in modules:
        deps=re.findall(r'^import (\S+)',(W/(mod+'.lean')).read_text(),re.M)
        dep_links=[f'<a href="../{d}.lean">{d}</a>' if d in modules else html.escape(d) for d in deps]
        pinned=f'https://github.com/alectionary/vibe-math/blob/{appendix["proof_commit"]}/formalization/distance-preservation/{mod}.lean'
        out+=f'<tr><td><a href="../{mod}.lean">{mod}.lean</a> · <a href="{pinned}">Immutable source</a><br><a href="../logs/{mod}.json">Build record</a> · <a href="../logs/{mod}.log">Log</a></td><td><code>{sha(W/(mod+".lean"))}</code></td><td>'+ '<br>'.join(dep_links)+'</td></tr>\n'
    out+='''</table><h2>Reproduction and evidence</h2><p><a href="README.txt">Instructions</a> ·
<a href="../clean-rebuild.json">Isolated rebuild</a> · <a href="../verification.json">Full investigation audit</a> ·
<a href="../SOURCE-TO-PROOF.txt">Semantic source map</a> · <a href="../prior-art.json">Prior-art and GitHub/X ledger</a> ·
<a href="SHA256SUMS.txt">Snapshot hashes</a></p>
<p>The fifty-module proof closure excludes the native-decision prototype and external negative searches.
The two generic auxiliary proofs have separate records and do not prove the proposed truncated bound.
The archive is a manuscript-focused subset; external experiments named by the historical full manifest
remain in the original investigation directory.</p></html>'''
    (P/'PROOF-GUIDE.html').write_text(out)

    # Preserve the manuscript layout and relative file links in the ZIP.
    selected=set()
    for mod in modules:
        selected.update([W/(mod+'.lean'), W/'logs'/(mod+'.json'), W/'logs'/(mod+'.log')])
    evidence=['verification.json','clean-rebuild.json','SOURCE-TO-PROOF.txt','RESEARCH-NOTE.txt',
        'PROTOCOL.txt','prior-art.json','closeout.json','build_lean.py','audit_artifact.py',
        'independent-family-verification.json','independent-verification.json',
        'independent-degenerate.json','frozen-matrix-crosschecks.json','search-repair.json',
        'search-regression-tests.json','historical-corrected-summary.json','SEARCH-SOUNDNESS.txt',
        'STRUCTURAL-ROUTE.txt','auxiliary-verification.json','auxiliary-fixed-columns-verification.json',
        'LowWeightChecks.lean','PermutationFixedColumns.lean','sat-crosscheck.json']
    selected.update(W/f for f in evidence)
    selected.update((W/'clean-rebuild-logs').glob('*.log'))
    for mod in ['LowWeightChecks','PermutationFixedColumns']:
        selected.update([W/'logs'/(mod+'.json'),W/'logs'/(mod+'.log'),W/'auxiliary-logs'/(mod+'.log')])
    for name in ['main.tex','main.pdf','README.txt','PROOF-GUIDE.html','proof-coverage.json',
                 'PaperAudit.lean','PaperAudit.log','paper-lean-audit.json','prepare_report.py','validate_report.py',
                 'report-source-checks.json','presentation-review.json','integrate_report.py',
                 'source-screen-recheck.json','rebuild_proofs.py',
                 'lean-environment/lakefile.toml','lean-environment/lean-toolchain',
                 'generate_appendix.py','appendix-listings.json','editorial-provenance.json',
                 'published-links.json']+manuscript_files:
        selected.add(P/name)
    extra={R/'formalization/dyadic-rank/lean-toolchain':'dependencies/lean-toolchain',
           R/'formalization/dyadic-rank/lake-manifest.json':'dependencies/lake-manifest.json',
           R/'.agents/skills/open-question-research/SKILL.md':'workflow/SKILL.md'}
    lake=list((R/'formalization/dyadic-rank').glob('lakefile.*'))
    extra.update({f:'dependencies/'+f.name for f in lake})
    paths={f:'distance-preservation/'+str(f.relative_to(W)) for f in selected}
    paths.update(extra)
    assert all(f.is_file() for f in paths), [str(f) for f in paths if not f.is_file()]
    hashes={rel:sha(f) for f,rel in sorted(paths.items(),key=lambda x:x[1])}
    sums=''.join(f'{h}  {name}\n' for name,h in hashes.items())
    (P/'SHA256SUMS.txt').write_text(sums)
    archive=P/'distance-preservation-source.zip'
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
        for f,rel in sorted(paths.items(),key=lambda x:x[1]):z.write(f,rel)
        z.writestr('distance-preservation/paper/SHA256SUMS.txt',sums)
    now=datetime.datetime.now(datetime.timezone.utc).isoformat()
    dump(P/'report-audit.json',{'status':'BUILT_PENDING_PRESENTATION_VALIDATION','built_utc':now,
        'manuscript_date':'2026-10-25','python':sys.executable,
        'paper_pdf_sha256':sha(P/'main.pdf'),'paper_tex_sha256':sha(P/'main.tex'),
        'manuscript_files_sha256':{f:sha(P/f) for f in manuscript_files},
        'source_archive_sha256':sha(archive),'source_archive_members':len(hashes)+1,
        'admitted_main_modules':50,'linked_declarations':len(refs),'proof_environments':len(proofs),
        'canonical_completion_delta':0,'source_problem_complete':False,
        'chronology_days':{'RDV2025':594,'FHM2026':137,'F86_first':87,'F89_first':87,
                          'F86_internal':62,'F89_internal':62},
        'classical_ingredient_age':'2004 year precision; approximately22years',
        'investigation_closeout':json.loads((W/'closeout.json').read_text()),
        'proof_source_commit':appendix['proof_commit'],
        'appendix_listings':len(appendix['listings']),
        'publication':'Mathematical proof sources published at recorded immutable pin; current manuscript build local until separately committed.',
        'artifact_members_sha256':hashes})
    print(json.dumps({'status':'BUILT','modules':50,'proofs':len(proofs),
                      'declarations':len(refs),'archive_members':len(hashes)+1}))

if __name__=='__main__':main()
