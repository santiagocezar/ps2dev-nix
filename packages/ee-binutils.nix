{ stdenv, fetchFromGitHub, gmp, mpfr, texinfo, bison, perl, flex }:

stdenv.mkDerivation {
  # goes into $PS2DEV/ee
  name = "ee-binutils";
  version = "2.31.1";
  src = fetchFromGitHub {
    owner = "ps2dev";
    repo = "binutils-gdb";
    rev = "39f9bf96301f59fbde9783919643c5ed5f5ae21a";
    hash = "sha256-ej4ds/LgRsInbrIiw60nZ7dRdsXNcayDJEAUboOuVSw=";
  };
  nativeBuildInputs = [
    bison
    perl
    flex
  ];
  buildInputs = [
    gmp
    mpfr
    texinfo
  ];
  enableParallelBuilding = true;
  configureFlags = [
    "--quiet"
    "--disable-nls"
    "--target=mips64r5900el-ps2-elf"
#     "--with-sysroot=$out/mips64r5900el-ps2-elf"
    "--disable-separate-code"
    "--disable-sim"
    "--disable-nls"
  ];
}
