#
# Builds the example project statically.
#

{ pkgs ? import ./nixpkgs-static.nix { } }:
(pkgs.pkgsCross.musl64.haskellPackages.callPackage ./example.nix { })
