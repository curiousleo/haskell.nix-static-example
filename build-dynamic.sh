#!/usr/bin/env bash
set -Eeuo pipefail

nix-build example.nix -A example.components.exes.example
