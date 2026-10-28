#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_pod_link info
PYTHONPATH=src python -m gbt_pod_link check --payload '{}'
PYTHONPATH=src python -m gbt_pod_link run   --payload '{}'
