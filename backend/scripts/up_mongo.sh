#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose -f docker-compose.yml up -d mongo

