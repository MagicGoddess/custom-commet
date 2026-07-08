# syntax=docker/dockerfile:1.7

ARG FLUTTER_VERSION=3.41.9
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    CARGO_HOME=/root/.cargo \
    RUSTUP_HOME=/root/.rustup \
    PUB_CACHE=/root/.pub-cache \
    FRB_DART_RUN_COMMAND_STDERR=1 \
    PATH=/root/.cargo/bin:/root/.pub-cache/bin:/sdks/flutter/bin:$PATH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        clang \
        cmake \
        curl \
        git \
        ninja-build \
        pkg-config \
        unzip \
        xz-utils \
        zip \
    && rm -rf /var/lib/apt/lists/*

ARG RUST_VERSION=1.96.1
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --profile minimal --default-toolchain "${RUST_VERSION}" \
    && rustup toolchain install nightly --profile minimal \
    && rustup target add wasm32-unknown-unknown \
    && rustup target add wasm32-unknown-unknown --toolchain nightly \
    && rustup component add rust-src --toolchain nightly

RUN git config --global --add safe.directory /src \
    && flutter config --enable-web \
    && flutter precache --web

WORKDIR /src
COPY . .

WORKDIR /src/commet

ARG VERSION_TAG=v0.0.0
ARG GIT_HASH=unknown
ARG BUILD_DETAIL=docker
ARG ENABLE_GOOGLE_SERVICES=false
ARG FRB_CODEGEN_VERSION=2.11.1

ENV FRB_CODEGEN_VERSION=${FRB_CODEGEN_VERSION}

RUN dart run scripts/codegen.dart
RUN ./scripts/prepare-web.sh
RUN dart run scripts/build_release.dart \
    --platform web \
    --version_tag "${VERSION_TAG}" \
    --git_hash "${GIT_HASH}" \
    --build_detail "${BUILD_DETAIL}" \
    --enable_google_services "${ENABLE_GOOGLE_SERVICES}"

FROM scratch AS web-artifacts
COPY --from=build /src/commet/build/web /

FROM nginx:1.27-alpine AS serve
COPY --from=build /src/commet/build/web /usr/share/nginx/html
