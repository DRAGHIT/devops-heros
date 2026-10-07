#!/bin/bash
set -euxo pipefail
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python -m pytest -v
bash build.sh
docker build -t aditya-session16:demo .
test "$(docker run --rm aditya-session16:demo)" = 15
