{ pkgs, src }:

let
  inherit (pkgs) lib stdenv;
in
  {
    dvp-binutils = stdenv.mkDerivation {
      name = "dvp-binutils";
      src = builtins.fetchGit src.dvp-binutils;
    };
  }
