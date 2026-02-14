{ config, ... }:
with config.lib.stylix.colors.withHashtag;
{
  services.mako = {
    enable = true;
    settings = {
      font = "${config.stylix.fonts.sansSerif.name} 12";
      padding = "10,20";
      anchor = "bottom-right";
      width = 400;
      height = 150;
      border-size = 2;
      default-timeout = 12000;
      background-color = "${base00}dd";
      border-color = "${base03}dd";
      text-color = "${base05}dd";
    };
  };
}
