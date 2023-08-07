{ config, pkgs, lib, ... }:

let inherit (config.colorscheme) colors;
in
{
  programs.gtklock = {
    enable = true;
    settings = {
      main = {
        gtk-theme = "Adwaita-dark";
      };
    };
  };
}
