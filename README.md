# Jasperro's Dotfiles

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

## Information
Welcome to Jasperro's dotfiles.

These are my configuration files for NixOS + home-manager, for multiple users and systems. I have been updating this repository for a long time, going from Ubuntu to Arch Linux and now (already a few years) NixOS.

This configuration is using nix for where immutability is a priority, using escape hatches when needed (like `impurity`), or podman/docker containers being updatable on the host itself. Nix(OS) makes many things easy, like rollbacks, per-project environments and remembering what you changed. But it can also be a pain.

Currently trying the "dendritic" pattern by using [vic/den](https://github.com/vic/den). I am still evaluating this library, feeling it might be one abstraction too much. I'm looking into making the module definitions based on directory structure and file names to prevent bugs, finding the middle ground between something like [haumea](https://github.com/nix-community/haumea) and a full dendritic (I don't really like the name) configuration. I'm looking into making an extension for [vic/import-tree](https://github.com/vic/import-tree), that provides file path and name to each module (with some utilities).

I'm trying to improve documentation. If you have a question, feel free to open an issue or discussion.

### Desktop configurations
* `hosts/doosje`
* `hosts/koekie`
### Laptop configurations
* `hosts/superlaptop`
* `hosts/waffie`
### Server configurations
* `hosts/taart`
### Home configurations
Every home-manager config is currently bound to a host in structure `homes/{user}-{host}.nix`.
### Modules
Modules are flake-parts modules, mostly using [vic/den](https://github.com/vic/den). See `modules/README.md` for info.

### Inspiration from (non-exhaustive list)
* [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
* [Swarsel/.dotfiles](https://github.com/Swarsel/.dotfiles)