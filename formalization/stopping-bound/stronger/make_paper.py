"""Compile the editable LaTeX manuscript; never generates mathematical claims.

Requires Tectonic on PATH, in TECTONIC, or supplied through --tectonic.
The main.tex/supplement.tex sources follow the repository's earlier papers.
"""
from pathlib import Path
import argparse, os, shutil, subprocess, tempfile

def main():
    root = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tectonic', default=os.environ.get('TECTONIC', 'tectonic'))
    parser.add_argument('--output-dir', type=Path,
                        default=Path(os.environ.get('PAPER_OUTPUT_DIR', str(root))))
    parser.add_argument('--only-cached', action='store_true')
    args = parser.parse_args()
    compiler = shutil.which(args.tectonic)
    if compiler is None:
        parser.error('Tectonic not found; set TECTONIC or pass --tectonic /path/to/tectonic')
    output = args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='stopping-latex-') as directory:
        temporary = Path(directory)
        for name in ('main.tex', 'supplement.tex'):
            shutil.copyfile(root / name, temporary / name)
        command = [compiler, '--keep-logs', '--outdir', str(temporary)]
        if args.only_cached:
            command.append('--only-cached')
        command.append(str(temporary / 'main.tex'))
        subprocess.run(command, check=True)
        log = (temporary / 'main.log').read_text(errors='replace')
        for failure in ('Missing character:', 'Overfull \\hbox', 'undefined references'):
            if failure in log:
                raise RuntimeError('Inspect the LaTeX log before publication: ' + failure)
        shutil.copyfile(temporary / 'main.pdf', output / 'stronger-stopping-paper.pdf')
        (output / 'latex-build.log').write_text('\n'.join(line.rstrip() for line in log.splitlines()) + '\n')
    print('Compiled stronger-stopping-paper.pdf from main.tex and supplement.tex.')

if __name__ == '__main__':
    main()
