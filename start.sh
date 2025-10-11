#!/bin/bash
set -e

python -c "import app.poll as poll; poll.init_db"
exec gunicorn -w 4 -b 0.0.0.0:8000 poll:app

