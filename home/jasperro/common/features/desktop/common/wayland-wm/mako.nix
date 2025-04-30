{ config, ... }:
with config.lib.stylix.colors.withHashtag;
{
  services.mako = {
    enable = true;
    font = "${config.stylix.fonts.sansSerif.name} 12";
    padding = "10,20";
    anchor = "bottom-right";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    backgroundColor = "${base00}dd";
    borderColor = "${base03}dd";
    textColor = "${base05}dd";
  };
}
