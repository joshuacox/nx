{
  description = "A flake for building nx";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable
  }: let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    suffix-version = version: attrs: nixpkgs.lib.mapAttrs' (name: value: nixpkgs.lib.nameValuePair (name + version) value) attrs;
    suffix-stable = suffix-version "-23_11";
  in {
    packages.x86_64-linux.default = self.packages.x86_64-linux.nx;
    packages.x86_64-linux.nx =
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
