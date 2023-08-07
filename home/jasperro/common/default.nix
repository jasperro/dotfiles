{ inputs, lib, pkgs, outputs, ... }: {

  imports = [
    ../../common
    ./features/cli
    ./features/desktop/hyprland
    ./features/editors/nixvim
  ];

  home = {
    username = lib.mkDefault "jasperro";
    pointerCursor = { package = pkgs.breeze-icons; gtk.enable = true; name = "breeze_cursors"; size = 24; };
  };

  # GTK config somehow breaks home-manager, maybe fix later?

  # gtk = {
  #   enable = true;
  #   theme = { package = pkgs.breeze-gtk; name = "Breeze"; };
  #   iconTheme = { package = pkgs.papirus-icon-theme; name = "Papirus Dark"; };
  # };
}
