{ overrideCC, stdenv, lib, binutils-unwrapped, gcc-unwrapped, wrapCCWith, wrapBintoolsWith, fetchFromGitHub }:

let
  stdenvPS2 = stdenv.override {
    targetPlatform = { config = "mips64r5900el-ps2-elf"; } // lib.systems.examples.mips64el-linux-gnuabi64;
  };

  ee-binutils = (binutils-unwrapped.override {
    stdenv = stdenvPS2;
    enableGold = false;
  }).overrideAttrs {
    version = "2.31.1";
    src = fetchFromGitHub {
      owner = "ps2dev";
      repo = "binutils-gdb";
      rev = "39f9bf96301f59fbde9783919643c5ed5f5ae21a";
      hash = "sha256-ej4ds/LgRsInbrIiw60nZ7dRdsXNcayDJEAUboOuVSw=";
    };
    patches = [];
  };
  cc = wrapCCWith rec {
    cc = gcc-unwrapped;
    bintools = wrapBintoolsWith {
      bintools = ee-binutils;
      libc = "newlib";
    };
  };
in

(overrideCC stdenvPS2 cc).mkDerivation {
  name = "env";
}
