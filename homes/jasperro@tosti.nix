{ den, jdf, ... }:
{
  den.aspects."jasperro@tosti" = {
    includes = [
      jdf.stylix

      jdf.users._.jasperro._.desktop._.niri
      jdf.users._.jasperro._.desktop-packages
      jdf.users._.jasperro._.git
      jdf.users._.jasperro._.cli

      jdf.users._.jasperro._.editors._.nixvim
      jdf.users._.jasperro._.editors._.vscode

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos.users.groups.jasperro.gid = 1000;

    xdg = {
      enable = true;
      createDirectories = true;
    };

    user = {
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      group = "jasperro";
      extraGroups = [
        "wheel"
        "http"
        "docker"
        "podman"
        "video"
        "uucp"
        "dialout"
        "kvm"
        "audio"
      ];

      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };

    homeManager =
      { pkgs, ... }:
      {
        stylix = {
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        };
      };
  };
}
