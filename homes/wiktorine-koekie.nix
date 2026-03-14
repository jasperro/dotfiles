{ __findFile, ... }:
{
  den.homes.x86_64-linux.wiktorine-koekie = {
    description = "Standalone home configuration for wiktorine's desktop computer.";
    aspect = "jasperro-wiktorine";
  };

  den.aspects.wiktorine-koekie = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          kdePackages.kdeconnect-kde
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
