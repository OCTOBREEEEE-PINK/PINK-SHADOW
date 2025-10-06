#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/../.."

if [ -f backend/.env ]; then
  export $(grep -v '^#' backend/.env | xargs -I {} echo {})
fi

uvicorn backend.server:app --reload --host 0.0.0.0 --port 8000

