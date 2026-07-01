#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME="${1:-speedtest-streamlit}"
PORT="${2:-8503}"
ENV_DIR="$SCRIPT_DIR/.venv"

is_port_free() {
  python3 -c 'import socket, sys
port = int(sys.argv[1])
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
try:
    s.bind(("127.0.0.1", port))
    s.close()
    sys.exit(0)
except OSError:
    sys.exit(1)
' "$1"
  return $?
}

if [ -n "$ENV_NAME" ] && [ "$ENV_NAME" != "speedtest-streamlit" ]; then
  ENV_DIR="$SCRIPT_DIR/$ENV_NAME"
fi

recreate_env=false
if [ ! -d "$ENV_DIR" ]; then
  recreate_env=true
  echo "Creating virtual environment '$ENV_DIR'..."
else
  if [ ! -x "$ENV_DIR/bin/python" ] || [ ! -f "$ENV_DIR/bin/streamlit" ]; then
    recreate_env=true
    echo "Existing virtual environment '$ENV_DIR' is invalid or broken; recreating..."
  else
    # Ensure the venv's python interpreter is valid
    if ! "$ENV_DIR/bin/python" -c 'import sys; print(sys.executable)' >/dev/null 2>&1; then
      recreate_env=true
      echo "Existing virtual environment '$ENV_DIR' has a broken Python interpreter; recreating..."
    else
      echo "Using existing virtual environment '$ENV_DIR'."
    fi
  fi
fi

if [ "$recreate_env" = true ]; then
  rm -rf "$ENV_DIR"
  python3 -m venv "$ENV_DIR"
fi

echo "Installing dependencies into '$ENV_DIR'..."
"$ENV_DIR/bin/python" -m pip install --upgrade pip
"$ENV_DIR/bin/python" -m pip install -r "$SCRIPT_DIR/requirements.txt"

if ! is_port_free "$PORT"; then
  echo "Port $PORT is already in use. Finding a free port..."
  for p in $(seq 8503 8600); do
    if is_port_free "$p"; then
      PORT="$p"
      break
    fi
  done
  echo "Using available port $PORT."
fi

echo "Starting Streamlit app on port $PORT..."
exec "$ENV_DIR/bin/python" -m streamlit run "$SCRIPT_DIR/streamlit_app.py" --server.headless true --server.port "$PORT"
