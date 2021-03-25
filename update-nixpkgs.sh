#!/usr/bin/env bash
set -Eeuo pipefail

nix-prefetch-git \
  https://github.com/input-output-hk/haskell.nix.git \
  --rev "refs/heads/master" \
  >./haskell-nix.json
