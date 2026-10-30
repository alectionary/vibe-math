"""Make minimal 600 dpi source-evidence excerpts; full thesis stays external."""
import argparse,hashlib,json,pathlib,subprocess,tempfile
from PIL import Image
p=argparse.ArgumentParser();p.add_argument('pdf');a=p.parse_args()
out=pathlib.Path(__file__).resolve().parents[1]/'evidence';out.mkdir(exist_ok=True)
# Coordinates in the 4961 x 7016 raster; retain table and equations, not full pages.
regions=[(48,'table3_1',(1200,680,3950,1920)),(45,'scaling_equations',(900,3940,4250,5000))]
records=[]
with tempfile.TemporaryDirectory() as tmp:
 for page,name,box in regions:
  stem=str(pathlib.Path(tmp)/name)
  subprocess.run(['pdftoppm','-f',str(page),'-l',str(page),'-r','600','-png','-singlefile',a.pdf,stem],check=True)
  im=Image.open(stem+'.png');im.crop(box).save(out/(name+'.png'),dpi=(600,600))
  records.append(dict(file=name+'.png',page=page,printed_page=page,dpi=600,box=list(box),sha256=hashlib.sha256((out/(name+'.png')).read_bytes()).hexdigest()))
(out/'manifest.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(pathlib.Path(a.pdf).read_bytes()).hexdigest(),source_url='https://github.com/artix41/artix41.github.io/blob/b4f401e0c12b44be4c69318e0015f70d8a3d3f98/assets/pdf/master-thesis-ucl.pdf',crops=records,rights='Limited attributed research evidence; excluded from repository Apache grant. Full dissertation not redistributed.'),indent=2)+'\n')
