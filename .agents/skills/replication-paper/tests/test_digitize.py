"""Digitizing recovers known plotted values within the stated reading error."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / "scripts"))

import digitize  # noqa: E402
import importlib.util  # noqa: E402

HAVE = {name: importlib.util.find_spec(name) is not None for name in ("matplotlib", "fitz", "PIL", "numpy")}

TRUE = [(-0.348, 1.0), (-0.23, 2.0), (-0.083, 3.0), (0.004, 4.0), (0.12, 5.0)]
RED = (0.97, 0.46, 0.43)


def _figure(path: Path, fmt: str) -> None:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(figsize=(4, 3))
    ax.set_xlim(-0.5, 0.25)
    ax.set_ylim(0, 6)
    for v, style in ((-0.10, "b"), (-0.05, "r"), (0.05, "r"), (0.10, "b")):
        ax.axvline(v, color=style, linestyle=":", linewidth=0.8)
    ax.scatter([x for x, _ in TRUE], [y for _, y in TRUE], color=RED, marker="s", s=12)
    fig.savefig(path, format=fmt, dpi=200)
    plt.close(fig)


class AxisTests(unittest.TestCase):
    def test_linear_axis_from_references(self):
        axis = digitize.Axis.from_references([(100, -0.1), (300, 0.1)])
        self.assertAlmostEqual(axis.value(200), 0.0)
        self.assertAlmostEqual(axis.value(400), 0.2)
        self.assertAlmostEqual(axis.error(1.0), 0.001)

    def test_log_axis_and_bad_references(self):
        axis = digitize.Axis.from_references([(0, 10), (100, 1000)], log=True)
        self.assertAlmostEqual(axis.value(50), 100)
        with self.assertRaises(ValueError):
            digitize.Axis.from_references([(5, 1), (5, 2)])

    def test_least_squares_reports_reference_misfit(self):
        axis = digitize.Axis.from_references([(0, 0.0), (100, 1.0), (200, 2.05)])
        self.assertGreater(axis.residual, 0.0)
        self.assertGreater(axis.error(0.0), 0.0)


@unittest.skipUnless(HAVE["matplotlib"] and HAVE["fitz"], "needs matplotlib and PyMuPDF")
class VectorTests(unittest.TestCase):
    def test_vector_markers_recover_plotted_values(self):
        with tempfile.TemporaryDirectory() as tmp:
            pdf = Path(tmp, "fig.pdf")
            _figure(pdf, "pdf")
            markers = [m for m in digitize.vector_markers(str(pdf), 1)
                       if all(abs(a - b) < 0.02 for a, b in zip(m["fill"], RED))]
            self.assertEqual(len(markers), len(TRUE))
            lines = digitize.vector_lines(str(pdf), 1)
            # vertical dotted reference lines at known values calibrate the x axis
            refs = {}
            for ln in lines:
                if abs(ln["x0"] - ln["x1"]) < 1e-6 and ln["color"] in ([1.0, 0.0, 0.0], [0.0, 0.0, 1.0]):
                    refs.setdefault(round(ln["x0"], 3), ln)
            xs = sorted(refs)
            self.assertEqual(len(xs), 4)
            axis = digitize.Axis.from_references(list(zip(xs, (-0.10, -0.05, 0.05, 0.10))))
            got = sorted(axis.value(m["x"]) for m in markers)
            for g, (want, _) in zip(got, sorted(TRUE)):
                self.assertAlmostEqual(g, want, delta=axis.error(0.05) + 1e-3)


@unittest.skipUnless(HAVE["matplotlib"] and HAVE["PIL"] and HAVE["numpy"], "needs matplotlib, Pillow and NumPy")
class RasterTests(unittest.TestCase):
    def test_raster_blobs_recover_values_within_reading_error(self):
        import numpy as np
        from PIL import Image

        with tempfile.TemporaryDirectory() as tmp:
            png = Path(tmp, "fig.png")
            _figure(png, "png")
            image = np.asarray(Image.open(png).convert("RGB"))
            blobs = digitize.raster_blobs(image, [int(255 * c) for c in RED], tol=30)
            self.assertEqual(len(blobs), len(TRUE))
            # calibrate from the red reference lines at -.05 and .05 (pure red columns)
            red_cols = np.nonzero(((image[..., 0] > 200) & (image[..., 1] < 60) & (image[..., 2] < 60)).sum(axis=0) > 20)[0]
            groups = np.split(red_cols, np.nonzero(np.diff(red_cols) > 2)[0] + 1)
            centers = [g.mean() for g in groups]
            self.assertEqual(len(centers), 2)
            axis = digitize.Axis.from_references(list(zip(centers, (-0.05, 0.05))))
            got = sorted(axis.value(b["x"]) for b in blobs)
            for g, (want, _), b in zip(got, sorted(TRUE), sorted(blobs, key=lambda b: b["x"])):
                self.assertAlmostEqual(g, want, delta=axis.error(b["x_error"]))


if __name__ == "__main__":
    unittest.main()
