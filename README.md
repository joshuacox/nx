# nx

nx is a helper shell wrapper around some common tasks I do on my NixOS systems.

## usage

nx -h 

### configuration

In your flake.nix:

```
{
  description = "A nx flake config";

  inputs = {
    nx.url = "github:joshuacox/nx";
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };
  outputs = inputs@{ nx, nixpkgs, ... }: {
    nixosConfigurations = {
      exampleHost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./../../nix/nx.nix
        ];
      };
    };
  };
}

```


nx.nix:
```
{ config, lib, pkgs, inputs, ... }:
let
in
{
  environment.systemPackages = with pkgs; [ 
    inputs.nx.packages."x86_64-linux".nx
  ];
}
```

There is a full [example repo](https://github.com/joshuacox/nx_example) showing a working setup with an example laptop host (laptop1), and an example group (example_group) which shows an example colmena remote setup of k3s with mixed x86_64 hosts and aarch64 (rpi4) hosts.
