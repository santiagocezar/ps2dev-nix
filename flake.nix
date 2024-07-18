{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      callPackage = pkgs.lib.callPackageWith (pkgs // localPkgs);
      localPkgs = {
        dvp-binutils = callPackage packages/dvp-binutils.nix {};
        ee-binutils = callPackage packages/ee-binutils.nix {};
        ee-gcc-stage1 = callPackage packages/ee-gcc-stage1.nix {};
        ee-newlib = callPackage packages/ee-newlib.nix {};
        ee-env = callPackage packages/ee-env.nix {};
      };
    in
      {
        packages.${system} = localPkgs;
      };
}
