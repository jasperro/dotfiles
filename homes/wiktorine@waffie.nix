{ den, jdf, ... }:
{
  den.aspects."wiktorine@waffie" = {
    includes = [
      jdf.cli._.jasperro-shell
      jdf.services._.kdeconnect

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos.users.groups.wiktorine.gid = 1003;

    user = {
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      group = "wiktorine";
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
        home.packages = with pkgs; [
          # general desktop apps
          firefox
          #firefox-devedition-bin
          gimp3
          inkscape
          qalculate-qt
          kdePackages.ark

          # X/Wayland utilities
          x11_ssh_askpass
          xeyes
          wl-clipboard
          wl-clipboard-x11
          waypipe
          waynergy
          wev

          dconf
          dconf-editor
          gparted

          # wine
          wine-wayland
          winetricks

          # multimedia
          pwvucontrol
          vlc

          # games
          prismlauncher

          # LaTeX
          # texlive.combined.scheme-medium
        ];
      };
  };
}
