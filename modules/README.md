# Modules
## General
`den.nix`: Import den module.

`namespace.nix`: Define namespaces (currently only JDF, which stands for Jasperro Dot Files). Most aspects need to be defined in this namespace directly.

`aspects/`: Generic aspects that should be default or included in most configurations. Only for stuff that doesn't fit anywhere else. Another name is probably better. Everything is in the `den` namespace.

`flake/`: Flake modules that don't fit in the dendritic pattern. Should define top-level flake outputs like packages, overlays, formatter, etc.

## Den
The naming scheme is very temporary, I will change it when implementing a auto-naming module.

`desktop/`: Desktop environments

`home/`: Home-manager custom modules
`nixos/`: Base NixOS features, should be included based on the type of computer (server, laptop, desktop, headless, etc.)

`services/`: Services on the host, which can be either NixOS or home-manager (or both).
`users/{user}/`: User-specific configurations (but can be included by other users), follows the same structure as the top-level directory.

## Per-host/home
Every host and home in the top directory is also a module, and can have its own modules. These should not be shared at all between hosts. Move them here if anything could be shared.