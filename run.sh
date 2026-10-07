#!/usr/bin/env bash
# Run Sedona Riemann-gas thermodynamics in ngn/k
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
K_BIN="${K_BIN:-/workspace/bin/k}"
if [[ ! -x "$K_BIN" ]]; then
  K_BIN="/workspace/k-src/ngn-k/k"
fi
if [[ ! -x "$K_BIN" ]]; then
  echo "error: ngn/k binary not found (tried /workspace/bin/k and /workspace/k-src/ngn-k/k)" >&2
  exit 1
fi
mkdir -p "$ROOT/logs"
cd "$ROOT"
# ngn/k exits via \\ in run.k; capture status
set +e
"$K_BIN" run.k
status=$?
set -e
# \\ exit may yield 0; treat missing log as failure
if [[ ! -f "$ROOT/logs/run-thermo.txt" ]]; then
  echo "error: log not written" >&2
  exit 1
fi
# stamp a dated copy (computed values only already in run-thermo.txt)
stamp=$(date +%Y%m%d-%H%M%S)
cp "$ROOT/logs/run-thermo.txt" "$ROOT/logs/run-${stamp}.txt"
echo "K_BIN=$K_BIN exit=$status log=logs/run-${stamp}.txt"
exit 0
