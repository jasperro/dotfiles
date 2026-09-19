{
  den,
  jdf,
  ...
}:
{
  den.aspects."jasperro@doosje" = {
    includes = [
      jdf.ui._.stylix

      jdf.jasperro._.ui._.umbriel
      jdf.jasperro._.ui._.noctalia

      jdf.jasperro._.packages._.desktop
      jdf.jasperro._.git
      jdf.jasperro._.cli

      jdf.jasperro._.editors._.nixvim
      jdf.jasperro._.editors._.vscode

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos.users.groups.jasperro.gid = 1000;

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
        "minecraft"
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
