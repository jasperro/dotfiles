# Home Configurations

This directory contains user-specific environment configurations managed by `home-manager`.

## Structure
Configurations here follow a strict naming convention: `{user}-{host}.nix`

Current configurations include:
- `colin-superlaptop.nix`
- `jasperro-doosje.nix`
- `jasperro-koekie.nix`
- `wiktorine-koekie.nix`
- `wiktorine-waffie.nix`

## Relationship to the rest of the repository
While the `../hosts/` directory configures the system-level components (NixOS, hardware, system services), the configurations here manage the user's personal environment (dotfiles, user packages, shell configs, GUI preferences). 

These configuration files primarily utilize the custom `home-manager` modules defined in `../modules/home/` and `../modules/desktop/`.
