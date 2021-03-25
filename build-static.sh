#!/usr/bin/env bash
set -Eeuo pipefail

nix-build example-static.nix -A example.components.exes.example
