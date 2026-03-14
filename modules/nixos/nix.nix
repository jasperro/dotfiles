{
  lib,
  config,
  inputs,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "build-time-fetch-tree"
        "ca-derivations"
        "pipe-operators"
      ];

      # Deduplicate and optimize nix store
      auto-optimise-store = lib.mkDefault true;
      warn-dirty = false;
      lazy-trees = true;
      eval-cores = 0;

      trusted-users = [
        "root"
        "@wheel"
      ];

      # Set to 500 MiB to hide warning
      download-buffer-size = 524288000;
    };

    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';

    # Add each flake input as a registry for the nix3 cli
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Additionally add each flake input to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    optimise = {
      automatic = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
