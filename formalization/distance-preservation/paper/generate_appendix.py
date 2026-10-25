"""Extract checked Lean declarations and generate exact PDF listings/deep links.

The fifty proof modules are unchanged. Each printed declaration is complete;
Unicode is converted to TeX escapes solely for typesetting. Provenance records
bind every displayed line range to the original source and published Git blob.
"""
from pathlib import Path
import ast, hashlib, json, re, subprocess

P=Path(__file__).resolve().parent
W=P.parent
PIN='98eb91cd9049e6a88887a5ba79150ad96a4a3e53'
BASE=f'https://github.com/alectionary/vibe-math/blob/{PIN}/formalization/distance-preservation'
NAMESPACES={'FamilyBaseDistance':'FamilyBaseGraph','FamilyDistance11':'FamilyClassical11',
            'SourceSectors':'SourceModel','TransposeConstant':'FamilyTranspose',
            'TransposeDistance':'FamilyTranspose','FamilyTheorem':'DistanceFamily',
            'ParametricSource':'ParametricWords','FamilyBounds':'DistanceFamily'}
SELECTIONS=[
 ('source-objects','GeneralLP',['HX','HZ','Syndrome','stabilizerLeft','stabilizerRight','InSpanX','LogicalX']),
 ('source-span','SourceSectors',['InSpanX','inSpanX_iff']),
 ('source-minimum','SourceWordBridge',['Kernel','InSpan','QuantumHasWeight']),
 ('parametric-word','ParametricWords',['e','U','V','witness_kernel']),
 ('separator-span','GeneralLP',['augmentation_stabilizer','full_span_left']),
 ('logical-separation','ParametricWords',['augmentation_witness','actual_logical']),
 ('physical-weight','ParametricWords',['supportList','zero_outside','weight_le']),
 ('source-obstruction','ParametricSource',['source_parametric_obstruction']),
 ('cancelled-fibers','CoverWeight',['push','zero_push_fiber_lower','zero_push_weight_doubles']),
 ('stopping-projection','CyclicCover',['projected_support_stopping']),
 ('cover-bound','CoverDistance',['lower_bound']),
 ('finite-certificate','FamilyDistance11',['encoded_lower','actual_classical_lower']),
 ('finite-weight-bridge','FamilyBaseDistance',['packWord_weight','code_lower_twelve']),
 ('tree-stopping','TannerSix',['stopping_lower_six']),
 ('cover-application','FamilyCoverAlternative',['classical_lower_twelve']),
 ('classical-upper','ClassicalUpper20',['word','kernel','nonzero','classical_distance_upper']),
 ('transpose-period','FamilyTranspose',['boundary','Kernel','third_period']),
 ('transpose-constant','TransposeConstant',['kernel_iff']),
 ('transpose-distance','TransposeDistance',['nonzero_weight','distance_characterization']),
 ('girth-eight','FamilyGirth',['eight_distinct','eight_edges','exact_eight_certificate']),
 ('connected','FamilyConnected',['shift','connected']),
 ('arithmetic-family','ParametricProjection',['projected_counterfamily']),
 ('minimum-bridge','SourceWordBridge',['block_weight_iff','quantum_weight_iff','quantum_distance_eq','classical_distance_eq']),
 ('final-distance','SourceWordBridge',['source_distance_drop']),
]

SYMBOLS={
 '∀':r'\forall','∃':r'\exists','→':r'\to','↔':r'\leftrightarrow',
 '≤':r'\le','≥':r'\ge','≠':r'\ne','∧':r'\land','∨':r'\lor',
 '¬':r'\neg','∑':r'\sum','∈':r'\in','∉':r'\notin','⊆':r'\subseteq',
 '×':r'\times','ˢ':r'{}^{\mathsf s}','⟨':r'\langle','⟩':r'\rangle',
 '·':r'\cdot','∣':r'\mid','ℤ':r'\mathbb Z','ℕ':r'\mathbb N',
 '⊕':r'\oplus','←':r'\leftarrow','↑':r'\uparrow','∅':r'\varnothing',
 '∘':r'\circ','ℝ':r'\mathbb R','₀':r'{}_0','₁':r'{}_1',
 '₂':r'{}_2','₃':r'{}_3','₄':r'{}_4','₅':r'{}_5','₆':r'{}_6',
 '₇':r'{}_7','₈':r'{}_8','₉':r'{}_9','ℓ':r'\ell',
 'α':r'\alpha','β':r'\beta','γ':r'\gamma','σ':r'\sigma','τ':r'\tau',
 '∏':r'\prod','≃':r'\simeq','≡':r'\equiv','ₘ':r'{}_{\mathsf m}',
}

def digest(data):return hashlib.sha256(data).hexdigest()

def tex_code(raw):
    unknown=sorted({c for c in raw if ord(c)>127 and c not in SYMBOLS})
    assert not unknown,('Missing typesetting symbols',unknown)
    return ''.join('(*@$'+SYMBOLS[c]+'$@*)' if c in SYMBOLS else c for c in raw)

def declaration(module,name):
    text=(W/(module+'.lean')).read_text()
    match=re.search(r'^(?:noncomputable )?(?:theorem|lemma|def|abbrev) '+re.escape(name)+r'\b',text,re.M)
    assert match,(module,name)
    after=text[match.end():]
    boundary=re.search(r'\n(?=(?:noncomputable )?(?:theorem|lemma|def|abbrev|instance) |#print |end |variable |open )',after)
    end=match.end()+boundary.start()+1 if boundary else len(text)
    raw=text[match.start():end]
    # A documentation comment for the next declaration is not part of this one.
    raw=re.split(r'\n/--',raw)[0].rstrip()+'\n'
    start_line=text[:match.start()].count('\n')+1
    return raw,start_line,start_line+len(raw.splitlines())-1

def main():
    frozen=json.loads((W/'clean-rebuild.json').read_text())
    modules=list(frozen['source_sha256'])
    assert len(modules)==50
    pinned=[]
    for mod in modules:
        data=(W/(mod+'.lean')).read_bytes()
        ns=re.search(r'^namespace ([A-Za-z0-9_.]+)',data.decode(),re.M)
        if ns:NAMESPACES[mod]=ns[1]
        assert digest(data)==frozen['source_sha256'][mod],mod
        path='formalization/distance-preservation/'+mod+'.lean'
        published=subprocess.check_output(['git','show',PIN+':'+path],cwd=W)
        assert published==data,('Pinned source differs',mod)
        pinned.append({'module':mod,'source_sha256':digest(data),
                       'git_blob':subprocess.check_output(['git','rev-parse',PIN+':'+path],cwd=W,text=True).strip()})
    out=P/'listings';out.mkdir(exist_ok=True)
    records=[]
    for key,mod,names in SELECTIONS:
        parts=[];declarations=[]
        for name in names:
            raw,first,last=declaration(mod,name)
            parts.append(raw)
            declarations.append({'name':NAMESPACES.get(mod,mod)+'.'+name,
                'first_line':first,'last_line':last,'raw_sha256':digest(raw.encode()),
                'url':f'{BASE}/{mod}.lean#L{first}-L{last}'})
        raw='\n'.join(parts)
        rendered=tex_code(raw)
        (out/(key+'.tex')).write_text(rendered)
        records.append({'id':key,'module':mod,'declarations':declarations,
            'source_sha256':digest((W/(mod+'.lean')).read_bytes()),
            'listing_sha256':digest(rendered.encode()),'raw_sha256':digest(raw.encode()),
            'raw_line_count':len(raw.splitlines()),'complete_declarations':True})
    targets={}
    for mod in modules:
        for match in re.finditer(r'^(?:noncomputable )?(?:theorem|lemma|def|abbrev) ([A-Za-z0-9_]+)',(W/(mod+'.lean')).read_text(),re.M):
            full=NAMESPACES.get(mod,mod)+'.'+match[1]
            targets[full]=(W/(mod+'.lean')).read_text()[:match.start()].count('\n')+1
    (P/'proof-targets.tex').write_text('% Generated declaration line anchors at the immutable proof commit.\n'+
        ''.join(r'\expandafter\def\csname leanline@'+name+r'\endcsname{'+str(line)+'}\n' for name,line in sorted(targets.items())))
    refs=re.findall(r'\\lean\{([^}]+)\}\{([^}]+)\}',(P/'main.tex').read_text())
    assert all(name in targets for _,name in refs),[name for _,name in refs if name not in targets]
    inputs=['% Generated complete-declaration source listings.']
    for record in records:
        names='; '.join(r'\lean{'+record['module']+'}{'+d['name']+'}' for d in record['declarations'])
        inputs.append(r'\expandafter\def\csname leanlisting@'+record['id']+r'\endcsname{'+
                      r'\par\smallskip\noindent\textbf{Checked source:} '+names+r'.\par\smallskip'+
                      r'\lstinputlisting{listings/'+record['id']+r'.tex}}')
    (P/'listing-inputs.tex').write_text('\n'.join(inputs)+'\n')
    linktex=[r'\clearpage\section{Complete current and immutable Lean URLs}\label{app:lean-links}',
        'The following index includes every admitted proof, certificate and research import.',
        r'All immutable links use commit \texttt{98eb91cd9049e6a88887a5ba79150ad96a4a3e53}.',
        'The declaration links in the text and preceding appendices go directly to source line ranges.',
        'Current links may evolve; the immutable sources match the audited hashes.',
        'The source archive and companion proof guide give the complete SHA-256 ledger and logs.']
    for mod in sorted(modules):
        linktex.extend([r'\par\smallskip\noindent\begin{minipage}{\linewidth}\small\setlength{\baselineskip}{11pt}',
            r'\textbf{Source file:} \nolinkurl{'+mod+r'.lean}\par\nopagebreak',
            r'Current: \url{https://github.com/alectionary/vibe-math/blob/master/formalization/distance-preservation/'+mod+r'.lean}\\',
            r'Immutable: \url{'+BASE+'/'+mod+r'.lean}\par\end{minipage}\par'])
    (P/'proof-file-index.tex').write_text('\n'.join(linktex)+'\n')
    (P/'appendix-listings.json').write_text(json.dumps({'proof_commit':PIN,'listings':records,
        'complete_source_modules':pinned,'scope':'Exact complete declaration extracts from unchanged checked modules; typesetting only.'},indent=2)+'\n')
    print(json.dumps({'status':'PASS','listings':len(records),'declarations':sum(len(x['declarations']) for x in records),
                      'raw_lean_lines':sum(x['raw_line_count'] for x in records),'pinned_source_modules':50}))

if __name__=='__main__':main()
