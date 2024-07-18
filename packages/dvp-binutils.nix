{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  # goes into $PS2DEV/dvp
  name = "dvp-binutils";
  version = "2.31.1";
  src = fetchFromGitHub {
    owner = "ps2dev";
    repo = "binutils-gdb";
    rev = "b019123770b896a09a77d050f634e37c0e2e84a5";
    hash = "sha256-ih54RUF0aPIpmhs38KwV6SgBQFVifyfGfOT5uVhDTuw=";
  };

  configureFlags = [
    "--quiet"
    "--disable-nls"
    "--target=dvp"
    "--disable-build-warnings"
  ];
}
