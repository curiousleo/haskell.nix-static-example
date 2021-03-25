{ pkgs ? import ./nixpkgs.nix { } }:
let
  isMusl = pkgs.stdenv.hostPlatform.isMusl;
  optionals = pkgs.lib.optionals;
  grpc-haskell-src =
    # To be released as version 0.1.0
    pkgs.fetchgit {
      url = "https://github.com/awakesecurity/gRPC-haskell.git";
      sha256 = "186g46b4zyjpqylikhfrwl7gq1vqa2b6jv40h786ayc8njgkrk6j";
      rev = "1bdc3662db13686f5e4941f3cc506f6fdf11ce32";
    };
  proto3-suite-src =
    # To be released as version 0.4.1
    pkgs.fetchgit {
      url = "https://github.com/awakesecurity/proto3-suite.git";
      sha256 = "1szana07fkjyi64a6p5pxijspc4d9735iv8jzfbgnxabdj0gnfi1";
      rev = "c40e73eb9a10e32d033aea3e2c8335af6c4c0926";
    };
in
pkgs.haskell-nix.cabalProject {
  src = ./.;
  modules = [
    {
      packages.proto3-suite = {
        src = proto3-suite-src;
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
      #packages.example.components.exes.example.configureFlags = pkgs.lib.mkForce (optionals isMusl [
      #  "--disable-executable-dynamic"
      #  "--disable-shared"
      #  "--ghc-option=-optl=-pthread"
      #  "--ghc-option=-optl=-static"
      #]);
    }
  ];

  # Specify the GHC version to use.
  compiler-nix-name = "ghc8104";

  # Fix inputs.
  index-state = "2021-03-24T00:00:00Z";
}
