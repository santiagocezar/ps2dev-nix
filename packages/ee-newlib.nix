{ ee-binutils, ee-gcc-stage1, gmp, mpfr, libmpc, texinfo, stdenv, fetchFromGitHub, wrapCCWith, wrapBintoolsWith }:

let
  mips64r5900el-ps2-cc = wrapCCWith {
    cc = ee-gcc-stage1;
    bintools = wrapBintoolsWith {
      bintools = ee-binutils;
      libc = "newlib";
    };
  };
in
mips64r5900el-ps2-cc/*
stdenv.mkDerivation {
  # goes into $PS2DEV/ee
  name = "ee-newlib";
  version = "4.4.0";

  nativeBuildInputs = [
    mips64r5900el-ps2-cc
    gmp
    mpfr
#     libmpc
    texinfo
  ];

  src = fetchFromGitHub {
    owner = "ps2dev";
    repo = "newlib";
    rev = "cad2e5752763713ad0d4ab3973436eaaf809c82a";
    hash = "sha256-4xHiyG5mMUBR84RU0qDw22ScZoGx7pvpSuIUZiDZjWI=";
  };

#     export PATH="${ee-binutils}/mips64r5900el-ps2-elf:$PATH"
#   preConfigure = ''
#     substituteInPlace configure --replace 'noconfigdirs target-newlib target-libgloss' 'noconfigdirs'
#     substituteInPlace configure --replace 'cross_only="target-libgloss target-newlib' 'cross_only="'
#   '';
#   configurePlatforms = [ "build" "target" ];
  configureFlags = [
    "--target=mips64r5900el-ps2-elf"
    "--with-sysroot=${mips64r5900el-ps2-cc}"
    "--enable-newlib-retargetable-locking"
    "--enable-newlib-multithread"
    "--enable-newlib-io-c99-formats"
  ];
}
*/
