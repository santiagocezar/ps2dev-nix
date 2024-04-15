{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ps2dev = pkgs.stdenv.mkDerivation {
        name = "ps2dev";
        src = pkgs.dockerTools.pullImage {
          imageName = "ps2dev/ps2dev";
          imageDigest = "sha256:5145529beab551bed561442094711211d467299c88054470e3d2d1c05b90a442";
          sha256 = "12viapmc07a840z1hwsgw9zl06w6z7c6908jdx02h9q0rxin2hdp";
          finalImageName = "ps2dev/ps2dev";
          finalImageTag = "latest";
        };
        nativeBuildInputs = [ pkgs.jq ];
        buildInputs = [ pkgs.musl ];
        unpackPhase = ''
          tar xf $src
        '';
        installPhase = ''
          relevant=$(jq -r '.[0].Layers.[-1]' manifest.json)
          mkdir "$out"
          tar xf "$relevant" -C "$out" --strip-components=3
        '';
        fixupPhase = ''
          for bin in $(find $out -executable -follow -type f); do
            if file $bin | grep "ELF"; then
              patchelf --set-interpreter "${pkgs.musl}/lib/ld-musl-x86_64.so.1" $bin || :
            fi
          done
        '';

        passthru = {
          shellHook = ''
            export PS2DEV="${ps2dev}"
            export PS2SDK="$PS2DEV/ps2sdk"
            export PATH="$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2DEV/dvp/bin:$PS2SDK/bin:$PATH"
          '';
        };
      };
      shell = pkgs.mkShell {
        inherit (ps2dev) shellHook;
      };
    in
      {
        devShells.${system}.default = shell;
        packages.${system} = {
          default = ps2dev;
        };
      };
}
