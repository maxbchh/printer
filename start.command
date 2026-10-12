#!/bin/zsh
cd "$(dirname "$0")"

PORT=8000
URL="http://127.0.0.1:$PORT"

if ! curl -fsS --max-time 2 "$URL" >/dev/null 2>&1; then
  if nc -z 127.0.0.1 "$PORT" >/dev/null 2>&1; then
    pids="$(lsof -tiTCP:"$PORT" -sTCP:LISTEN)"
    if [ -n "$pids" ]; then
      kill $pids
      sleep 1
    fi
  fi
  python3 -m http.server "$PORT" --bind 127.0.0.1 &
fi

sleep 1
open -a "Google Chrome" "$URL"
