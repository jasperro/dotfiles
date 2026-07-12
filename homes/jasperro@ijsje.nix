{ den, jdf, ... }:
{
  den.aspects."jasperro@ijsje" = {
    includes = [
      jdf.stylix

      jdf.users._.jasperro._.desktop._.niri
      jdf.users._.jasperro._.git
      jdf.users._.jasperro._.cli

      jdf.users._.jasperro._.editors._.nixvim

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos.users.groups.jasperro.gid = 1000;

    user = {
      uid = 1000;
      initialPassword = "jasperro";
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
    };

    homeManager =
      { pkgs, ... }:
      {
        stylix = {
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        };
        home.packages = with pkgs; [
          kdePackages.dolphin
          kdePackages.dolphin-plugins
          kdePackages.ark
          kdePackages.kate
          kdePackages.konsole

          librewolf
          x11_ssh_askpass
          xeyes
          wl-clipboard
          wl-clipboard-x11

          dconf
          dconf-editor
          gparted

          pwvucontrol
        ];
      };
  };
}
