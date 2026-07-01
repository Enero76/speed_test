#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME="${1:-speedtest-streamlit}"
PORT="${2:-8503}"
ENV_DIR="$SCRIPT_DIR/.venv"

if [ -n "$ENV_NAME" ] && [ "$ENV_NAME" != "speedtest-streamlit" ]; then
  ENV_DIR="$SCRIPT_DIR/$ENV_NAME"
fi

if [ ! -d "$ENV_DIR" ]; then
  echo "Creating virtual environment '$ENV_DIR'..."
  python3 -m venv "$ENV_DIR"
else
  echo "Using existing virtual environment '$ENV_DIR'."
fi

echo "Installing dependencies into '$ENV_DIR'..."
"$ENV_DIR/bin/python" -m pip install --upgrade pip
"$ENV_DIR/bin/python" -m pip install -r "$SCRIPT_DIR/requirements.txt"

echo "Starting Streamlit app on port $PORT..."
exec "$ENV_DIR/bin/streamlit" run "$SCRIPT_DIR/streamlit_app.py" --server.headless true --server.port "$PORT"
