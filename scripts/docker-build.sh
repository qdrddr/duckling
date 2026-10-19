#!/usr/bin/env bash
# Build Duckling container images for one or more platforms.
#
# Examples:
#   ./scripts/docker-build.sh linux/arm64 --load -t duckling:arm64
#   ./scripts/docker-build.sh linux/amd64,linux/arm64 \
#     -t bbkudk/duckling:0.2.0.2-r4 -t bbkudk/duckling:latest --push
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

platform="${DOCKER_PLATFORM:-linux/arm64}"
extra_args=()

if [[ $# -gt 0 && "$1" != -* ]]; then
  platform="$1"
  shift
fi

while [[ $# -gt 0 ]]; do
  extra_args+=("$1")
  shift
done

docker buildx build \
  --platform "$platform" \
  --file Dockerfile \
  "${extra_args[@]}" \
  .
