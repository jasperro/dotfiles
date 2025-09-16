# Share common settings between home-manager and nixos for nix
# Currently all home-manager configurations run on nixos, so this is now unused in hm.
{
  lib,
  inputs,
  config,
  ...
}:
{
  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = [
        "nix-command"
        "flakes"
        "build-time-fetch-tree"
      ];
      # Deduplicate and optimize nix store
      auto-optimise-store = lib.mkDefault true;
      warn-dirty = false;
      lazy-trees = true;

      trusted-users = [
        "root"
        "@wheel"
      ];

      # Set to 500 MiB to hide warning
      # download-buffer-size = 524288000;
    };

    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
