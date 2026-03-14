{ __findFile, ... }:
{
  den.homes.x86_64-linux.wiktorine-waffie = {
    description = "Standalone home configuration for wiktorine's laptop.";
    aspect = "wiktorine-waffie";
  };

  den.aspects.wiktorine-waffie = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          kdePackages.kdeconnect-kde
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
