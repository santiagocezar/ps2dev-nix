{ stdenv, ee-binutils, fetchFromGitHub, gmp, mpfr, libmpc, flex }:

stdenv.mkDerivation {
  # goes into $PS2DEV/dvp
  name = "gcc-stage1";
  version = "14.1.0";
  buildInputs = [
    gmp
    mpfr
    libmpc
    flex
#     ee-binutils
  ];
  src = fetchFromGitHub {
    owner = "ps2dev";
    repo = "gcc";
    rev = "916c16f43e21906f00ecb0f0d46ca6b83f2cfb47";
    hash = "sha256-SGFNqbyjvkkTR3v7s3QQvwe8dcUt0snaQ85kYEmaHB4=";
  };
#   enableParallelBuilding = true;

  hardeningDisable = [ "all" ];

  configureFlags = [
    "--quiet"
    "--target=mips64r5900el-ps2-elf"
    "--enable-languages=c"
#     "--with-sysroot=${ee-binutils}/mips64r5900el-ps2-elf"
    "--with-float=hard"
    "--without-headers"
    "--without-newlib"
    "--disable-libgcc"
    "--disable-shared"
    "--disable-threads"
    "--disable-multilib"
    "--disable-libatomic"
    "--disable-nls"
    "--disable-tls"
    "--disable-libssp"
    "--disable-libgomp"
    "--disable-libmudflap"
    "--disable-libquadmath"
  ];
}
