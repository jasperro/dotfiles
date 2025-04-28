{ config, ... }:
let
  inherit (config.colorscheme) palette variant;
in
{
  services.mako = {
    enable = true;
    font = "${config.fontProfiles.regular.family} 12";
    padding = "10,20";
    anchor = "bottom-right";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    backgroundColor = "#${palette.base00}dd";
    borderColor = "#${palette.base03}dd";
    textColor = "#${palette.base05}dd";
  };
}
