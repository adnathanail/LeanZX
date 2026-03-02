import base64
import io

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

import pyzx as zx

from .types import ZXLeanGraph


def render_to_base64(g: ZXLeanGraph) -> str:
    """Render a pyzx graph to a base64-encoded PNG string."""
    fig = zx.draw_matplotlib(g, labels=True, figsize=(8, 2))
    buf = io.BytesIO()
    fig.savefig(buf, format="png", bbox_inches="tight", dpi=150)
    plt.close(fig)
    buf.seek(0)
    return base64.b64encode(buf.read()).decode("ascii")
