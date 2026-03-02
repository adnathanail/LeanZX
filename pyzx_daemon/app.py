from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route("/diagram", methods=["POST"])
def diagram():
    data = request.get_json()
    node_count = len(data.get("nodes", []))
    return jsonify({"status": "ok", "node_count": node_count})


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5050)
