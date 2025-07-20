{
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./sops.nix
    ../../../lib/sharedNixConfig.nix
  ];
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin"
  '';
  environment.localBinInPath = true;
  environment.systemPackages = with pkgs; [
    home-manager # support for standalone home-manager

    # general tools
    wget
    w3m
    screen
    fastfetch

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

  programs.zsh.enable = true;

  nix = {
    optimise = {
      automatic = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
    ];

    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };
}
