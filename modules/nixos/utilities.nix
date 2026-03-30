{
  # outputs,
  ...
}:
{
  JDF.nixos._.utilities.nixos =
    { pkgs, ... }:
    {
      key = "utilities";
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

      services.dbus.implementation = "broker";

      nixpkgs = {
        # overlays = [
        #   outputs.overlays.default
        # ];

        config = {
          allowUnfree = true;
        };
      };

      # Thanks, PriceHiller! (https://pricehiller.com/posts/private-git-submodule-authentication-and-nixos-rebuilds)
      security.sudo.extraConfig = ''
        Defaults env_keep+=SSH_AUTH_SOCK
      '';
    };
}
