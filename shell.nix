{pkgs ? import<nixpkgs>{} }:
with pkgs;

let
  fixJuliaPkgs = writeScriptBin "fixJuliaPkgs" ''
    #!/usr/bin/env bash

    PKG_DIR=~/.julia/artifacts

    for ARTIFACT in $(find ~/.julia/artifacts/*/bin) 
    do
      chmod +w $ARTIFACT
      ${patchelf}/bin/patchelf \
        $ARTIFACT \
        --set-interpreter \
        "$(cat $NIX_CC/nix-support/dynamic-linker)"
      chmod -w $ARTIFACT
    done
    '';
in
mkShell {
  buildInputs = [
    file
    fixJuliaPkgs
    julia-stable-bin
  ];
}
