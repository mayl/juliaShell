# juliaShell

An example `nix-shell` for working with `Julia`.  Only "interesting" thing is
that it includes a quick and dirty, brute force `fixJuliaPkgs` script which can
be called after adding a package and patch in the `nix` dynamic loader.

The script attempts to `patchELF` everything that `Julia`'s `Pkg` downloads to
use the `nix` dynamic loader. It seems like `patchELF` is "smart" enough to
only operate on files which are actual `elf` files, and which need to have the
dynamic loader overwritten.

Again, quick, dirty,and brute force, but this is _hopefully_ just a stop-gap
until someone modifies the `nixpkgs` derivation to patch `Pkgs` to do this
automaticaly
