import os
from flask import Flask, request, jsonify, render_template
import pymysql

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")
DB_NAME = os.getenv("DB_NAME", "polls")

app = Flask(__name__, template_folder="templates", static_folder="static")

def get_conn():
    return pymysql.connect(
        host=DB_HOST, user=DB_USER, password=DB_PASS, database=DB_NAME,
        cursorclass=pymysql.cursors.Cursor, autocommit=True
    )

def init_db():
    sql = """
    CREATE TABLE IF NOT EXISTS votes (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      choice VARCHAR(64) NOT NULL,
      voted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(sql)

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")

@app.route("/vote", methods=["POST"])
def vote():
    payload = request.get_json(silent=True) or {}
    choice = payload.get("choice")
    if not choice or len(choice) > 64:
        return jsonify({"error": "Invalid choice"}), 400
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO votes (choice) VALUES (%s)", (choice,))
    return jsonify({"success": True})

@app.route("/results", methods=["GET"])
def results():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT choice, COUNT(*) FROM votes GROUP BY choice")
            rows = cur.fetchall()
    return jsonify({k: v for k, v in rows})

@app.route("/health", methods=["GET"])
def health():
    try:
        with get_conn() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
        return "OK", 200
    except Exception:
        return "DB ERROR", 500

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8000)
