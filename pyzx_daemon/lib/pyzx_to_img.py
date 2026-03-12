import base64
import io

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pyzx as zx

from .types import ZXLeanGraph


def render_to_base64(g: ZXLeanGraph) -> str:
    """Render a pyzx graph to a base64-encoded PNG string."""
    # Scale figsize based on graph dimensions
    rows = set(g.row(v) for v in g.vertices())
    qubits = set(g.qubit(v) for v in g.vertices())
    width = max(len(rows) * 1.5, 6)
    height = max(len(qubits) * 1.2, 2)
    fig = zx.draw_matplotlib(g, labels=True, figsize=(width, height))
    buf = io.BytesIO()
    fig.savefig(buf, format="png", bbox_inches="tight", dpi=150)
    plt.close(fig)
    buf.seek(0)
    return base64.b64encode(buf.read()).decode("ascii")
