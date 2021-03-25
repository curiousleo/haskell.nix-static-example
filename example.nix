{ pkgs ? import ./nixpkgs.nix { } }:
let
  isMusl = pkgs.stdenv.hostPlatform.isMusl;
  optionals = pkgs.lib.optionals;
  grpc-haskell-src =
    pkgs.fetchgit {
      url = "https://github.com/awakesecurity/gRPC-haskell.git";
      sha256 = "0ywdww4bg3w088292lymh4xv2vbb8i2pqqh02pbf69lgmw1j4k28";
      rev = "0c57ab0785d34afcbb7c7832bf836f1a10cb450c";
    };
in
pkgs.haskell-nix.cabalProject {
  src = ./.;
  modules = [
    {
      packages.proto3-suite = {
        flags.dhall = false;
        components.tests.test.buildable = pkgs.lib.mkForce false;
      };

      packages.grpc-haskell-core = {
        src = grpc-haskell-src + "/core";
        components.library.libs = pkgs.lib.mkForce ([
          pkgs.coreutils-prefixed
          pkgs.grpc
        ]);
      };

      packages.grpc-haskell.src = grpc-haskell-src;

      # These don't help :/
      #packages.example.components.exes.example.configureFlags = optionals isMusl [
      #  "--disable-executable-dynamic"
      #  "--disable-shared"
      #  "--ghc-option=-optl=-pthread"
      #  "--ghc-option=-optl=-static"
      #];
    }
  ];

  # Specify the GHC version to use.
  compiler-nix-name = "ghc8104";

  # Fix inputs.
  index-state = "2021-03-16T21:48:58Z";
}
