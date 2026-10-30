"""Additional minimal attributed 600dpi evidence; keep full thesis external."""
import pathlib,sys,tempfile,subprocess,json,hashlib
from PIL import Image
source=pathlib.Path(sys.argv[1]);out=pathlib.Path(__file__).resolve().parents[1]/'evidence';records=[]
# PDF-point coordinates converted to the 600dpi raster.
regions=[(53,'table3_2',(108,78,510,246)),(52,'cubic_bias_figure',(184,145,451,320)),(56,'rhombic_bias_figure',(184,140,451,305)),(45,'methods_grid',(108,105,510,267))]
with tempfile.TemporaryDirectory() as tmp:
 for page,name,rect in regions:
  stem=str(pathlib.Path(tmp)/name);subprocess.run(['pdftoppm','-f',str(page),'-singlefile','-r','600','-png',str(source),stem],check=True);box=tuple(round(v*600/72) for v in rect);im=Image.open(stem+'.png');dest=out/(name+'.png');im.crop(box).save(dest,dpi=(600,600));records.append(dict(file=dest.name,page=page,dpi=600,pdf_points=rect,pixel_box=box,sha256=hashlib.sha256(dest.read_bytes()).hexdigest()))
(out/'expansion-manifest.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),source_url='https://github.com/artix41/artix41.github.io/blob/b4f401e0c12b44be4c69318e0015f70d8a3d3f98/assets/pdf/master-thesis-ucl.pdf',crops=records,rights='Limited attributed evidence excerpts; outside Apache grant. Full thesis not redistributed.'),indent=2)+'\n')
