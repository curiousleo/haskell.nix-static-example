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
  proto3-suite-src =
    pkgs.fetchgit {
      url = "https://github.com/awakesecurity/proto3-suite.git";
      sha256 = "0mpy35r6qd1v5sixhy2lqcn5x81rfj4dc079g1kpa4fb1f23dbha";
      rev = "0af901f9ef3b9719e08eae4fab8fd700d6c8047a";
    };
in
pkgs.haskell-nix.cabalProject {
  src = ./.;
  modules = [
    {
      packages.proto3-suite = {
        src = proto3-suite-src;
        #patches = [ ./proto3-suite.patch ];
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

      #packages.haskeline.flags.terminfo = !isMusl;
    }
  ];

  # Specify the GHC version to use.
  compiler-nix-name = "ghc8104";

  # Fix inputs, allow caching
  index-state = "2021-03-16T21:48:58Z";

  # https://input-output-hk.github.io/haskell.nix/tutorials/materialization/#how-can-we-check-sha256-and-materialized-are-up-to-date
  #materialized = ./example.materialized;
  #plan-sha256 = "";
}
