{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: let pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {

    packages.x86_64-linux.fixJuliaPkgs = pkgs.writeScriptBin "fixJuliaPkgs" ''
      #!/usr/bin/env bash

      PKG_DIR=~/.julia/

      for ARTIFACT in $(find $PKG_DIR/artifacts/*/bin) 
      do
      chmod +w $ARTIFACT
      ${pkgs.patchelf}/bin/patchelf \
      $ARTIFACT \
      --set-interpreter \
      "$(cat $NIX_CC/nix-support/dynamic-linker)"
      chmod -w $ARTIFACT
      done
      '';

      devShell.x86_64-linux = pkgs.mkShell{
        buildInputs = with pkgs; [
          file
          julia-bin
          self.packages.x86_64-linux.fixJuliaPkgs
        ];
      };

    };
  }
