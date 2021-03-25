#
# Provides the "unstable" Nixpkgs package set shipped with haskell.nix.
#

{ overlays ? [ ] }:
let
  haskellNixSrc = builtins.fromJSON (builtins.readFile ./haskell-nix.json);
  haskellNix = import
    (builtins.fetchTarball {
      url = "https://github.com/input-output-hk/haskell.nix/archive/${haskellNixSrc.rev}.tar.gz";
      inherit (haskellNixSrc) sha256;
    })
    { };
  nixpkgsSrc = haskellNix.sources.nixpkgs-unstable;
  nixpkgsArgs = haskellNix.nixpkgsArgs;
in
import nixpkgsSrc (nixpkgsArgs // { overlays = nixpkgsArgs.overlays ++ overlays; })
