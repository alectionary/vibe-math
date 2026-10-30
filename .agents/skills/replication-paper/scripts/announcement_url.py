"""Check only public-announcement URL syntax and expected destination.

Does not fetch the page or certify publication, PDF contents or descriptive
quality. Review/delivery URLs elsewhere are intentionally outside this scope.
"""
import argparse,json,re
from urllib.parse import urlsplit

def check_announcement_url(url,repository,pdf_path):
 errors=[]
 if not all(isinstance(v,str) and v for v in (url,repository,pdf_path)):return ['URL, repository and PDF path must be nonempty strings']
 try:p=urlsplit(url)
 except ValueError:return ['invalid URL']
 if p.scheme!='https' or p.netloc!='github.com' or p.query or p.fragment:errors.append('use HTTPS github.com without credentials, ports, query or fragment')
 if not re.fullmatch(r'[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+',repository):errors.append('repository must be owner/repo')
 parts=pdf_path.split('/')
 if len(parts)<2 or any(part in ('','.','..') or not re.fullmatch(r'[A-Za-z0-9_.-]+',part) for part in parts):errors.append('use an actual filesystem-safe repository PDF path')
 filename=parts[-1]
 if not filename.endswith('.pdf') or filename.lower() in ('paper.pdf','report.pdf','document.pdf'):errors.append('use the descriptive main-paper PDF filename')
 if p.path!='/'+repository+'/blob/master/'+pdf_path:errors.append('URL must match the expected repository and PDF path on master')
 return errors

if __name__=='__main__':
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('url');p.add_argument('--repository',required=True);p.add_argument('--pdf-path',required=True);a=p.parse_args()
 errors=check_announcement_url(a.url,a.repository,a.pdf_path);print(json.dumps({'errors':errors,'publication_verified':False},indent=2));raise SystemExit(bool(errors))
