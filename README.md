# nx

nx is a helper shell wrapper around some common tasks I do on my NixOS systems.

This was inspired by [Wil T's Nix Guides](https://nixos.wiki/wiki/Wil_T_Nix_Guides)

And then adding in the colmena setup using these [blog posts](https://haseebmajid.dev/posts/2023-11-30-til-how-to-use-sops-nix-with-colmena/)

## usage

nx -h 

```
nx - one less letter to type than nix
nx is an opinionated tool I use to manage my NixOS installations.
by default it uses a directory in your home '~/.nx'
USAGE:
apply-colmena:          nx ac GROUP
apply-system:           nx as
git-commit-am:          nx am
apply-user:             nx au
full-auto:              nx auto
edit-config:            nx ec
edit-flake:             nx ef
edit-group-flake:       nx ef GROUP
edit-user-config:       nx eu
garbage-collector:      nx gc
optimize:               nx o
search PACKAGE:         nx s PACKAGE
update-system:          nx us
update-user:            nx uu
```

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
