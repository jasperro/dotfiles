{ den, jdf, ... }:
{
  den.aspects."ewa@superlaptop" = {
    includes = [
      jdf.cli._.jasperro-shell
      jdf.services._.kdeconnect

      den.batteries.define-user
      (den.batteries.user-shell "zsh")
    ];

    nixos.users.groups.ewa.gid = 1007;

    user = {
      uid = 1007;
      initialPassword = "correcthorsebatterystaple";
      group = "ewa";
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
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # general desktop apps
          firefox
          qalculate-qt
          kdePackages.ark

          # Office
          libreoffice
          hyphen
          hunspell
          hunspellDicts.en_US
          hunspellDicts.nl_nl
          hunspellDicts.pl_PL

          # X/Wayland utilities
          x11_ssh_askpass
          xeyes
          wl-clipboard
          wl-clipboard-x11
          waypipe
          wev

          dconf

          # wine
          wine-wayland
          winetricks

          # multimedia
          pwvucontrol
          vlc

          # creative
          gimp3
          inkscape
          krita
          darktable
        ];
      };
  };
}
