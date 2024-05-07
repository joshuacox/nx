# nx

nx is one less letter to type than nix!

nx is a helper shell wrapper around some common tasks I do on my NixOS systems.

and if nx doesn't recognize the command it passes it to nix anyhow!

So you might as well just type `nx`

### usage

nx -h 

```
nx - one less letter to type than nix
nx is an opinionated tool I use to manage my NixOS installations.
by default it uses a directory in your home '~/.nx'
USAGE:
apply-colmena:          nx ac GROUP
apply-colmena-on-host:  nx ac GROUP host1
apply-colmena-on-hosts: nx ac GROUP host2,host3
apply-system:           nx as
git-commit-am:          nx am
apply-user:             nx au
full-auto:              nx auto
edit-config:            nx ec
edit-flake:             nx ef
edit-group-flake:       nx ef GROUP
edit-user-config:       nx eu
garbage-collector:      nx gc
optimize and gc:        nx o
search PACKAGE:         nx s PACKAGE
update-system:          nx us
update-user:            nx uu
# Or to do the apply in mini groups
# separate hosts in a group with a comma
# and groups with a space
apply-colmena-on-hosts: nx ac GROUP host1 host2,host3 host4,host5,host6
```

### installation

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

### configuration

There is a full [example repo](https://github.com/joshuacox/nx_example) showing a working setup with an example laptop host (laptop1), and an example group (example_group) which shows an example colmena remote setup of k3s with mixed x86_64 hosts and aarch64 (rpi4) hosts.

### main concepts 

The main idea is that we want to avoid using root/sudo to edit /etc/nixos and instead keep all those files in our users directory (by default we'll use `~/.nx`, but this can be altered by setting the env var `NX_DIR`).  At first these files were copied manually then this script was developed and eventually turned into flakes.

The first to be made were the apply-system.sh and apply-user.sh from [Wil T's Nix Guides](https://nixos.wiki/wiki/Wil_T_Nix_Guides) were turned into

`nx as`
and
`nx au`

And then the update scripts:

`nx us`
and
`nx uu`

Then I added a helper to edit the configuration.

`nx ec`

Then I added another machine that I was installing nix on, to separate things out I made a hosts directory and started choosing the right confg file to be editing or applying based on the output of `hostname`.

There are a few convenience functions added like:

`nx s gimp` which simplifies the lengthy amount of options that must be fed to nix to get it to search. for example the equivalent nix is:

`nix --extra-experimental-features "nix-command flakes" search nixpkgs gimp`

`nx gc` garbage collection 
`nx o` optimizations (*also does a garbage collect before-hand)

`nx auto` which queues up `us as uu au gc o` as a full-update macro.  

Eventually this was all enhanced to use flakes instead of all the copying around so the edit flake function was added:

`nx ef`  edit-flake

Then I added the colmena groups directory as well. This gave arise to the group flake edit by adding the groupname as an argument:

`nx ef GROUP`  edit flake.nix in the groups directory (e.g. `~/.nx/groups/example_group`)

likewise an apply for group as well:

`nx ac GROUP`  colmena apply in the groups directory

So the groups directory are meant to be remote hosts to be managed with colmena, while the hosts directory is meant for local systems where hostname should return the name of the directory in the hosts directory for the local machine about to be built on.

### inspiraton

This was inspired by [Wil T's Nix Guides](https://nixos.wiki/wiki/Wil_T_Nix_Guides)

And then adding in the colmena setup using these [blog posts](https://haseebmajid.dev/posts/2023-11-30-til-how-to-use-sops-nix-with-colmena/)

This script is meant to save keystrokes first and foremost!

I have considered adding in long form options i.e. edit-config instead of just ec, but the whole point of this script is to save myself keystrokes so for now I'm leaving them out.

I'd like to add that this shell script flys directly in the face of the recommendations about abbreviations [here](https://nixos.org/manual/nix/stable/contributing/cli-guideline). While I agree with their decision, again the purpose of this was to save me keystrokes, and deduplication in my shell history.

Pull requests welcome!
