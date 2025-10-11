import os
import logging
from flask import Flask, request, jsonify, render_template
import psycopg2
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

# 🔹 Logging setup
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

# 🔹 Prometheus metrics
vote_counter = Counter("votes_total", "Total number of votes", ["choice"])

# 🔹 Environment variables
DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")
DB_NAME = os.getenv("DB_NAME", "polls")

# 🔹 Flask app
app = Flask(__name__, template_folder="templates", static_folder="statics")

# 🔹 Database connection
def get_conn():
    conn = psycopg2.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        dbname=DB_NAME
    )
    conn.autocommit = True
    return conn

# 🔹 Initialize DB
def init_db():
    sql = """
    CREATE TABLE IF NOT EXISTS votes (
      id BIGSERIAL PRIMARY KEY,
      choice VARCHAR(64) NOT NULL,
      voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(sql)

# 🔹 Routes
@app.route("/")
def index():
    return render_template("index.html")

@app.route("/vote", methods=["POST"])
def vote():
    payload = request.get_json(silent=True) or {}
    choice = payload.get("choice")
    if not choice or len(choice) > 64:
        logger.warning(f"Invalid vote attempt: {payload}")
        return jsonify({"error": "Invalid choice"}), 400
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO votes (choice) VALUES (%s)", (choice,))
        vote_counter.labels(choice=choice).inc()
        logger.info(f"Vote recorded: {choice}")
        return jsonify({"success": True})
    except Exception as e:
        logger.error(f"Vote failed: {e}")
        return jsonify({"error": "Vote failed"}), 500

@app.route("/results", methods=["GET"])
def results():
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT choice, COUNT(*) FROM votes GROUP BY choice")
                rows = cur.fetchall()
        return jsonify({k: v for k, v in rows})
    except Exception as e:
        logger.error(f"Failed to fetch results: {e}")
        return jsonify({"error": "Failed to fetch results"}), 500

@app.route("/health", methods=["GET"])
def health():
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
        return "OK", 200
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return "DB ERROR", 500

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}

@app.route("/info")
def info():
    return jsonify({
        "version": "1.0.0",
        "status": "running"
    })

# 🔹 Entry point
if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8000)

