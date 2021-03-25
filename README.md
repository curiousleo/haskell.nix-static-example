# Requirements

[Nix][nix] must be installed, and you should have [IOHK's binary cache set up][haskell-nix-setup].

# Build

Build a dynamically linked executable:

    ./build-dynamic.sh

Build a statically linked executable:

    ./build-static.sh

# Update

Update the haskell.nix version:

    ./update-nixpkgs.sh

Then update the `index-state` in `example.nix`.

Regenerate gRPC service:

    ./generate-service.sh

[nix]: https://nixos.org/
[haskell-nix-setup]: https://input-output-hk.github.io/haskell.nix/tutorials/getting-started/#setting-up-the-binary-cache
