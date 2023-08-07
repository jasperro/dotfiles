# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    ../../common
    ./features/cli
    ./features/desktop
  ];

  home = {
    username = "colin";
    pointerCursor = { package = pkgs.breeze-icons; gtk.enable = true; name = "breeze_cursors"; size = 24; };
  };

}

