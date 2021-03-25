#
# Provides the default Nixpkgs package set with static overlays.
#

args@{ overlays ? [ ], ... }:
let
  example = pkgs: (pkgs.callPackage ./example.nix { }).example;
  combinedOverlays = overlays ++
    [
      (_self: super: {
        abseil-cpp = super.abseil-cpp.overrideAttrs (old: {
          cmakeFlags = [
            "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
          ];
        });
      })
      (self: super: {
        grpc = super.grpc.overrideAttrs (old: {
          cmakeFlags = old.cmakeFlags ++ [
            "-DBUILD_SHARED_LIBS=OFF"
            "-DgRPC_BUILD_CODEGEN=OFF"
          ];
          buildInputs = old.buildInputs ++ [ self.libnsl ];
        });
      })
    ];
in
import ./nixpkgs.nix (args // { overlays = combinedOverlays; })
