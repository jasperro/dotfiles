# Host Configurations

This directory contains the system-level configurations for the different machines (NixOS hosts) managed in this repository.

## Structure
Each subdirectory corresponds to a specific machine:
- **Desktop configurations:** `doosje` and `koekie`
- **Laptop configurations:** `superlaptop` and `waffie`
- **Server configurations:** `taart`

Inside each host directory, you will typically find:
- A main Nix file for the host (e.g., `doosje.nix`)
- A hardware configuration file (`_hardware-configuration.nix`)
- Host-specific component and service configurations (`services/` or `_services/`)

## Relationship to the rest of the repository
These host configurations are the top-level definitions for each machine. They build upon the core NixOS modules defined in `../modules/nixos` and incorporate user environments via `../homes/`. Secrets defined in `../secrets/` may also be decrypted and used for specific hosts (like `taart`).

**Note:** Any generic configuration that could apply to more than one host should be extracted and moved to the `../modules` folder so it can be reused across different environments.
