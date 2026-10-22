"""Re-run recorded lexical discovery against pinned clones; never infer proof status."""
import pathlib,json,subprocess,sys
R=pathlib.Path(__file__).resolve().parent.parent;A=R/'audit'
if len(sys.argv)!=2:raise SystemExit('Usage: python3 scripts/search_coverage.py SOURCE_ROOT')
root=pathlib.Path(sys.argv[1]).resolve()
sources=json.loads((A/'sources.json').read_text())
for s in sources:
 p=root/s['id']
 rev=subprocess.check_output(['git','-C',str(p),'rev-parse','HEAD'],text=True).strip()
 assert rev==s['revision'],f"Revision mismatch for {s['id']}: {rev}"
log=json.loads((A/'local-source-searches.json').read_text())
for s in log:
 p=root/s['repository'];sub=p/s['subdirectory'];assert sub.is_dir(),sub
 cmd=['rg','-l','-i','--glob','*.lean',s['regex'],str(sub)]
 result=subprocess.run(cmd,text=True,capture_output=True)
 assert result.returncode in (0,1),(cmd,result.stderr)
 s['exit_code']=result.returncode
 s['matching_files']=sorted(str(pathlib.Path(x).relative_to(p)) for x in result.stdout.splitlines())
(A/'local-source-searches.json').write_text(json.dumps(log,indent=2)+'\n')
print(f'Recorded {len(log)} searches. Matching filenames require semantic review; statuses were not changed.')
