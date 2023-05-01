{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    ./sops.nix
  ];
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin"
  '';
  environment.localBinInPath = true;
  environment.systemPackages = with pkgs; [
    # general tools
    acpi
    acpid
    arp-scan
    youtube-dl
    wget
    wget2
    w3m
    sloccount
    screen
    nnn
    neofetch
    meld

    zoxide
    silver-searcher
    ripgrep

    # (de)compression
    zip
    unzip
    p7zip

    sshfs
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = lib.mkDefault true;
      warn-dirty = false;

      trusted-users = [ "root" "@wheel" ];
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
}
