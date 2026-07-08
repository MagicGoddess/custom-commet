#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-${ROOT_DIR}/build/docker-web}"
FLUTTER_VERSION="${FLUTTER_VERSION:-3.41.9}"
RUST_VERSION="${RUST_VERSION:-1.96.1}"
VERSION_TAG="${VERSION_TAG:-v0.0.0}"
BUILD_DETAIL="${BUILD_DETAIL:-docker}"
ENABLE_GOOGLE_SERVICES="${ENABLE_GOOGLE_SERVICES:-false}"
FRB_CODEGEN_VERSION="${FRB_CODEGEN_VERSION:-2.11.1}"

if GIT_HASH="$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null)"; then
  :
else
  GIT_HASH="unknown"
fi
GIT_HASH="${GIT_HASH_OVERRIDE:-${GIT_HASH}}"

mkdir -p "${OUT_DIR}"

DOCKER_BUILDKIT=1 docker buildx build \
  --file "${ROOT_DIR}/docker/web.Dockerfile" \
  --target web-artifacts \
  --output "type=local,dest=${OUT_DIR}" \
  --build-arg "FLUTTER_VERSION=${FLUTTER_VERSION}" \
  --build-arg "RUST_VERSION=${RUST_VERSION}" \
  --build-arg "VERSION_TAG=${VERSION_TAG}" \
  --build-arg "GIT_HASH=${GIT_HASH}" \
  --build-arg "BUILD_DETAIL=${BUILD_DETAIL}" \
  --build-arg "ENABLE_GOOGLE_SERVICES=${ENABLE_GOOGLE_SERVICES}" \
  --build-arg "FRB_CODEGEN_VERSION=${FRB_CODEGEN_VERSION}" \
  "${ROOT_DIR}"

printf 'Web build written to %s\n' "${OUT_DIR}"
