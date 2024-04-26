{
  description = "A flake for building nx";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "nx";
        src = self;
        buildPhase = "cp -v src/nx ./nx";
        installPhase = "TMP=$(mktemp -d) && cp nx $TMP/nx && chmod 555 $TMP/nx && mkdir -p $out/bin && install -t $out/bin $TMP/nx";
      };

  };
}
