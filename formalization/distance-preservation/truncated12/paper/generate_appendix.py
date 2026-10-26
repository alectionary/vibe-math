"""Generate complete checked-source listings, declaration links and proof coverage."""
from pathlib import Path
import hashlib,html,json,re,subprocess,sys
P=Path(__file__).resolve().parent;R=P.parent;ROOT=R.parents[2]
sys.path.insert(0,str(R));from replay_round import local_import_order
PIN='3ae21c0719cedbd928f4f7882f9b9e266567605e'
CURRENT='research/RQ-F25-truncated-distance-12-round2-f0515dd8'
SECTIONS=[
 ('Source matrices, full spans and exact distances','The source interface fixes actual binary coefficients, every stabilizer row combination and the extended-natural minimum convention.',[
 ('GeneralLP',['HX','HZ','InSpanX']),('GeneralSymmetry',['fullSpanX','fullSpanZ']),('DistanceMinima',['sourceClassicalHasWeight','sourceClassicalDistance','sourceTransposeHasWeight','sourceTransposeDistance','sourceQuantumHasWeight','sourceQuantumDistance'])]),
 ('Actual incidence and the three profiles','The source kernel is the input of the count classification. The abstract normal graph and local edge bounds are proved in its imports, rather than assumed as new hypotheses.',[
 ('ActualIncidence',['source_kernel_zero_or_two']),('SourceProfiles',['source_mixed_count_profiles'])]),
 ('Constant rows and canonical support encodings','The following complete declarations show the actual support-to-catalog interfaces, including the exceptional constant-label branch.',[
 ('ConstantRows',['constant_singleton_rows']),('SourceSeven',['source_seven_singleton_profile_stabilizer']),('TenGeometry',['source_ten_geometry']),('TenEncoding',['ten_geometry_encodes','actual_canonical_ten_support_encodes']),('K23Numbering',['actual_k23_numbering']),('ElevenGeometry',['actual_eleven_geometry']),('SourceEleven',['source_canonical_eleven_stabilizer'])]),
 ('Integer certificate interpretation and cyclic torsion','Integer identities are interpreted in every additive group. The finite catalog supplies witnesses to this checked implication; it supplies no additional axiom.',[
 ('IntegerSoundness',['integer_certificate_sound']),('KernelCatalog',['checked_fast_equations']),('PatternRealizations',['PatternRealization','certified_pattern_has_no_source_realization']),('TorsionClassical',['torsionWord','source_classical_word_le10']),('CoverageCore',['Covered','covered_single','covered_append'])]),
 ('Transport and the complete global reduction','Canonical group placement is discharged by permutation and re-normalization. The global proof below includes all three profiles and the pure sectors.',[
 ('ProfileTransport',['DistanceCriterion','normPerm_criterion','normPerm_span']),('TwelveConditional',['source_kernel_below_twelve_of_coverage'])]),
 ('Pauli union weight and the literal minimum theorem','Both sectors and the entire product of stabilizer spans are retained. The public theorem discharges finite coverage before passing to literal minima.',[
 ('PauliBridge',['pauli_bound_of_x_bound']),('ThroughEleven',['source_pauli_bound_twelve']),('DistanceMinima',['source_classical_minimum_realized','source_classical_minimum_lower','source_transpose_zero_kernel_infinity','source_quantum_minimum_lower_iff']),('CriterionScope',['no_full_row_of_no_triple']),('DistanceTwelve',['source_distance_bound_twelve'])])]
COVERAGE=[
 ('thm:main','Literal source-distance bound',[('DistanceTwelve','source_distance_bound_twelve')]),
 ('lem:incidence','Actual coefficients, short cycles and paired checks',[('ActualIncidence','classical_incidence'),('ActualIncidence','quantum_incidence'),('ActualIncidence','quantum_no_four'),('ActualIncidence','quantum_no_six'),('ActualIncidence','source_kernel_zero_or_two')]),
 ('lem:profiles','Parity, local Mantel bounds and exhaustive profiles',[('BlockParity','common_block_parity'),('BlockCounts','common_count_parity'),('LocalMantel','source_left_local_mantel'),('LocalMantel','source_right_local_mantel'),('CountPatterns','count_cases_length'),('CountPatterns','classified_of_mem_countCases'),('SourceProfiles','source_mixed_count_profiles')]),
 ('lem:transport','Full source transport and canonical placement',[('ProfileTransport','normPerm_criterion'),('ProfileTransport','normPerm_kernel'),('ProfileTransport','normPerm_span'),('ProfileTransport','normPerm_weight'),('CountCanonical','ten_left_marker'),('CountCanonical','ten_right_marker'),('CountCanonical','eleven_left_marker')]),
 ('lem:singleton','Constant or injective singleton labels and full-row cancellation',[('SupportSingletons','actual_singleton_label_alternative'),('ConstantRows','constant_singleton_rows'),('RowCancellation','single_exception_cancellation'),('SourceSeven','source_seven_singleton_profile_stabilizer')]),
 ('lem:ten','Actual paired weight-ten source encoding',[('TenGeometry','source_ten_geometry'),('TenEncoding','actual_canonical_ten_support_encodes'),('TenIndex','tenRank_bound')]),
 ('lem:eleven','Actual colored K2,3 and weight-eleven source encoding',[('ExceptionalGraph','exceptional_group_is_k23'),('ElevenEncoding','eleven_geometry_encodes'),('SourceEleven','source_canonical_eleven_stabilizer')]),
 ('lem:cert','Full integer identities, universal interpretation and source obstruction',[('IntegerSoundness','integer_certificate_sound'),('KernelCatalog','checked_fast_equations'),('PatternRealizations','certified_pattern_has_no_source_realization'),('TargetObstructions','source_target_obstruction')]),
 ('lem:torsion','Classical alternatives without division',[('TorsionClassical','torsion_card_le'),('TorsionClassical','torsionWord_source_kernel'),('TorsionClassical','source_classical_word_le10'),('IntegerSoundness','row_small_torsion_impossible'),('IntegerSoundness','column_two_torsion_impossible')]),
 ('prop:coverage','Quantified certificate coverage',[('SourceSeven','seven_certificates_complete'),('Coverage10','complete_coverage10'),('Coverage11','complete_coverage11'),('CoverageCore','covered_append')]),
 ('lem:global','Pure sectors and complete full-span reduction',[('PureDistance','pure_left_zero_below_classical'),('PureDistance','pure_right_zero_below_transpose'),('TwelveConditional','source_kernel_below_twelve_of_coverage'),('ThroughEleven','source_kernel_below_twelve_is_stabilizer')]),
 ('lem:pauli','Actual sector symmetry and ordinary union weight',[('GeneralSymmetry','full_span_swap'),('GeneralSymmetry','kernel_swap'),('GeneralSymmetry','swap_weight'),('PauliBridge','pauli_bound_of_x_bound'),('ThroughEleven','source_pauli_bound_twelve')]),
 ('prop:minima','Actual classical/transpose/quantum minima',[('DistanceMinima','source_classical_minimum_realized'),('DistanceMinima','source_classical_minimum_lower'),('DistanceMinima','source_transpose_zero_kernel_infinity'),('DistanceMinima','source_quantum_minimum_lower_iff')])]
SYMBOLS=dict(zip('∀∃→↔≤≥≠∧∨¬∑∈∉⊆×⟨⟩·∣ℤℕ⊕←↑∅∘ℝ∏≃≡∞⊤⊥∩∪∖↦',
 [r'\forall',r'\exists',r'\to',r'\leftrightarrow',r'\le',r'\ge',r'\ne',r'\land',r'\lor',r'\neg',r'\sum',r'\in',r'\notin',r'\subseteq',r'\times',r'\langle',r'\rangle',r'\cdot',r'\mid',r'\mathbb Z',r'\mathbb N',r'\oplus',r'\leftarrow',r'\uparrow',r'\varnothing',r'\circ',r'\mathbb R',r'\prod',r'\simeq',r'\equiv',r'\infty',r'\top',r'\bot',r'\cap',r'\cup',r'\setminus',r'\mapsto']))
for c,n in zip('αβγδεζηθικλμνξοπρστυφχψω',['alpha','beta','gamma','delta','epsilon','zeta','eta','theta','iota','kappa','lambda','mu','nu','xi','omicron','pi','rho','sigma','tau','upsilon','phi','chi','psi','omega']):SYMBOLS[c]='\\'+n
for i,c in enumerate('₀₁₂₃₄₅₆₇₈₉'):SYMBOLS[c]='{}_'+str(i)
SYMBOLS.update({'•':r'\bullet','ℚ':r'\mathbb Q','ℂ':r'\mathbb C','ᵀ':r'{}^{\mathsf T}','⊔':r'\sqcup','⊓':r'\sqcap','ℓ':r'\ell','ˢ':r'{}^{\mathsf s}','ₘ':r'{}_{\mathsf m}'})
def sha(data):return hashlib.sha256(data).hexdigest()
def code_tex(raw):
 unknown=sorted({c for c in raw if ord(c)>127 and c not in SYMBOLS});assert not unknown,unknown
 return ''.join('(*@$'+SYMBOLS[c]+'$@*)' if c in SYMBOLS else c for c in raw)
def tex(s):return s.replace('_',r'\_').replace('&',r'\&').replace('%',r'\%')
def main():
 v=json.loads((R/'verification.json').read_text());assert v['main_source_distance_theorem_completed']
 paths={p.stem:p for base in [R.parent,R,R/'catalog-chunks'] for p in base.glob('*.lean')};mods=local_import_order(['DistanceTwelve','CriterionScope']);assert len(mods)==269
 all_needed={(m,n) for _,_,groups in SECTIONS for m,names in groups for n in names}|{tuple(d) for _,_,ds in COVERAGE for d in ds}
 has_pin=subprocess.run(['git','cat-file','-e',PIN+'^{commit}'],cwd=ROOT,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0
 targets={};sources=[]
 for mod in mods:
  p=paths[mod];raw=p.read_text();relative=str(p.relative_to(ROOT));data=p.read_bytes()
  assert sha(data)==v['modules'][mod]['source_sha256']
  if has_pin:assert subprocess.check_output(['git','show',PIN+':'+relative],cwd=ROOT)==data
  ns=re.search(r'^namespace (\S+)',raw,re.M);ns=ns[1] if ns else ''
  url=f'https://github.com/alectionary/vibe-math/blob/{PIN}/{relative}';current=f'https://github.com/alectionary/vibe-math/blob/{CURRENT}/{relative}'
  sources.append(dict(module=mod,path=relative,source_sha256=sha(data),url=url,current_url=current,imports=re.findall(r'^import (.+)$',raw,re.M),record=v['modules'][mod]['record'],log_sha256=v['modules'][mod]['log_sha256']))
  for match in re.finditer(r'^(?:noncomputable )?(?:theorem|lemma|def|abbrev|structure) (\w+)',raw,re.M):
   name=match[1]
   if (mod,name) not in all_needed:continue
   after=raw[match.end():];boundary=re.search(r'\n(?=(?:noncomputable )?(?:theorem|lemma|def|abbrev|structure|instance) |#print |end |variable |open )',after);end=match.end()+boundary.start()+1 if boundary else len(raw)
   declaration=re.split(r'\n/--',raw[match.start():end])[0].rstrip()+'\n';line=raw[:match.start()].count('\n')+1
   targets[(mod,name)]=dict(module=mod,name=name,qualified=(ns+'.' if ns else '')+name,line=line,last_line=line+len(declaration.splitlines())-1,raw=declaration,url=url+f'#L{line}-L{line+len(declaration.splitlines())-1}')
 all_needed={(m,n) for _,_,groups in SECTIONS for m,names in groups for n in names}|{tuple(d) for _,_,ds in COVERAGE for d in ds}
 missing=sorted(all_needed-targets.keys());assert not missing,missing
 (P/'listings').mkdir(exist_ok=True);appendix=[];records=[]
 for index,(title,explanation,groups) in enumerate(SECTIONS,1):
  appendix += [r'\clearpage\section{'+title+'}',explanation]
  for mod,names in groups:
   for name in names:
    d=targets[(mod,name)];key=mod+'-'+name;rendered=code_tex(d['raw']);(P/'listings'/(key+'.tex')).write_text(rendered)
    appendix += [r'\subsection*{\texttt{'+tex(mod)+'}: '+tex(name)+'}',r'\noindent\href{'+d['url']+r'}{Complete checked declaration at the immutable proof commit.}',r'\lstinputlisting{listings/'+key+'.tex}']
    records.append({k:z for k,z in d.items() if k!='raw'}|dict(listing=key+'.tex',raw_sha256=sha(d['raw'].encode()),listing_sha256=sha(rendered.encode()),complete_declaration=True))
 (P/'lean-appendix.tex').write_text('\n\n'.join(appendix)+'\n')
 macros=[]
 for (mod,name),d in targets.items():macros.append(r'\expandafter\def\csname proof@'+mod+'.'+name+r'\endcsname{\href{'+d['url'].replace('#',r'\#')+r'}{\nolinkurl{'+d['qualified']+'}}}')
 (P/'proof-targets.tex').write_text('\n'.join(macros)+'\n')
 cov=[];rows=[]
 for label,title,ds in COVERAGE:
  decls=[{k:z for k,z in targets[tuple(d)].items() if k!='raw'} for d in ds];cov.append(dict(manuscript_label=label,component=title,declarations=decls,status='exact_source_PASS'))
  links='; '.join(r'\lean{'+m+'}{'+n+'}' for m,n in ds)
  rows.append(r'\ref{'+label+'}: '+title+' & '+links+r'\\[5pt]')
 (P/'proof-coverage.tex').write_text(r'\begin{longtable}{@{}P{.30\textwidth}P{.65\textwidth}@{}}'+'\n'+r'\toprule Manuscript proof & Checked Lean declarations\\\midrule\endhead'+'\n'+'\n'.join(rows)+'\n'+r'\bottomrule\end{longtable}'+'\n')
 links=[r'\clearpage\section{Complete research-source link index}\label{app:links}',r'Every module in the final theorem and source-scope audit is listed below. Each row has a link to the preserved research branch and an immutable link at commit \nolinkurl{'+PIN+'}. The source archive includes these exact files and their matching build records. The accompanying HTML guide provides hashes and imports.',r'\footnotesize\begin{longtable}{@{}P{.62\textwidth}P{.14\textwidth}P{.14\textwidth}@{}}',r'\toprule Module & Current & Immutable\\\midrule\endhead']
 for d in sources:links.append(tex(d['path'].replace('formalization/distance-preservation/',''))+' & '+r'\href{'+d['current_url']+r'}{source} & \href{'+d['url']+r'}{source}\\')
 links += [r'\bottomrule\end{longtable}\normalsize'];(P/'source-links.tex').write_text('\n'.join(links)+'\n')
 doc=['<!doctype html><meta charset="utf-8"><title>Truncated distance proof guide</title><style>body{max-width:1000px;margin:40px auto;font:16px/1.5 system-ui}table{border-collapse:collapse}td,th{border:1px solid #ccc;padding:8px}code{overflow-wrap:anywhere;font-size:12px}</style><h1>Truncated distance through weight eleven</h1><p>Literal theorem: <b>dQ ≥ min(dC,12)</b>, under the exact strengthened normalized 3×4 cyclic source criterion. Proof commit: <code>'+PIN+'</code>.</p><p>All 183,312 cases and the complete 269-module research closure pass. Main theorem: <a href="'+targets[('DistanceTwelve','source_distance_bound_twelve')]['url']+'">source_distance_bound_twelve</a>.</p><table><tr><th>Module</th><th>Sources</th><th>Exact source SHA256 / imports</th></tr>']
 for d in sources:doc.append('<tr><td>'+html.escape(d['module'])+'</td><td><a href="'+d['url']+'">immutable</a> · <a href="'+d['current_url']+'">current</a></td><td><code>'+d['source_sha256']+'</code><br>'+html.escape('; '.join(d['imports']))+'</td></tr>')
 doc.append('</table>');(P/'PROOF-GUIDE.html').write_text('\n'.join(doc))
 (P/'proof-coverage.json').write_text(json.dumps(dict(proof_commit=PIN,modules=269,proofs=cov,listings=records,sources=sources),indent=2)+'\n')
 audit=['import DistanceTwelve','import CriterionScope','set_option maxHeartbeats 0']
 for m,n in sorted(all_needed):audit += ['#check '+targets[(m,n)]['qualified'],'#print axioms '+targets[(m,n)]['qualified']]
 (P/'ReportAudit.lean').write_text('\n'.join(audit)+'\n')
 print(json.dumps(dict(modules=len(mods),complete_listings=len(records),listed_lines=sum(x['last_line']-x['line']+1 for x in records),audited_declarations=len(all_needed),proof_components=len(cov))))
if __name__=='__main__':main()
