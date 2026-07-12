{ den, __findFile, ... }:
{
  den.aspects."wiktorine@koekie" = {
    includes = [
      <JDF/cli/jasperro-shell>
      <JDF/services/kdeconnect>

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
        # For waypipe
        "input"
        "uinput"
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
          vscode
          firefox
          gimp3
          inkscape
          krita
          qalculate-qt
          kdePackages.ark

          # Office
          libreoffice
          hyphen
          hunspell
          hunspellDicts.en_US
          hunspellDicts.nl_nl

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
          (lutris.override {
            extraPkgs = pkgs: [
              pkgs.mangohud
            ];
          })
          steam
          prismlauncher
          heroic
        ];
      };
  };
}
