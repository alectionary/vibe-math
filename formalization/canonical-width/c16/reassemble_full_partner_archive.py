#!/usr/bin/env python3
"""Reassemble a losslessly byte-sharded projection archive, verifying every hash."""
from pathlib import Path
import argparse,hashlib,json


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();m=json.loads(a.manifest.read_text());assert m['format']=='ordered_raw_byte_shards_v1'
    assert not a.output.exists(),'Refusing to overwrite an existing archive'
    a.output.parent.mkdir(parents=True,exist_ok=True);total=hashlib.sha256();written=0
    try:
        with a.output.open('xb') as output:
            for part in m['parts']:
                assert part['offset']==written
                path=a.manifest.parent/part['file'];digest=hashlib.sha256();size=0
                with path.open('rb') as source:
                    while chunk:=source.read(1024*1024):
                        digest.update(chunk);total.update(chunk);output.write(chunk);size+=len(chunk)
                assert size==part['bytes'] and digest.hexdigest()==part['sha256'],('invalid_shard',part['file'])
                written+=size
        assert written==m['original_bytes'] and total.hexdigest()==m['original_sha256'],'Reassembled archive hash mismatch'
    except BaseException:
        a.output.unlink(missing_ok=True)
        raise
    print(json.dumps({'status':'PASS','bytes':written,'sha256':total.hexdigest(),'shards':len(m['parts'])}))


if __name__=='__main__':main()
