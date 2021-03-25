#!/usr/bin/env bash
set -Eeuo pipefail

$(nix-build --no-out-link example.nix -A example.project.hsPkgs.proto3-suite.components.exes.compile-proto-file)/bin/compile-proto-file \
  --proto example_service.proto \
  --out .
