{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ps2dev = pkgs.stdenv.mkDerivation {
        name = "ps2dev";
        src = pkgs.dockerTools.pullImage {
          imageName = "ps2dev/ps2dev";
          imageDigest = "sha256:5b1e631d2fa8be5b00d8283f0c54e4e26e6bf562cfdb95704a8a6bf0b519283e";
          sha256 = "07av23kmcgv7cib2ki04h5xrhq7rgkjispvgg1pabpf8lx7bb51d";
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
