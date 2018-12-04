#!/bin/sh

set -o errexit
set -o pipefail
set -o nounset

exec /swarm-smoke $@ 2>&1
