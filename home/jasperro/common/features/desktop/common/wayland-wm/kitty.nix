{ config, pkgs, ... }:
let
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.programs.kitty.package}/bin/kitty -1 "$@"
  '';
in
with config.lib.stylix.colors.withHashtag;
{
  home = {
    packages = [ kitty-xterm ];
    sessionVariables = {
      TERMINAL = "kitty -1";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = config.stylix.fonts.monospace.name;
      size = 12;
    };
    settings = {
      shell_integration = "no-rc"; # I prefer to do it manually
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 15;
      cursor_trail = 1;
      background_opacity = 0.9;
      foreground = "${base05}";
      background = "${base00}";
      selection_background = "${base05}";
      selection_foreground = "${base00}";
      url_color = "${base04}";
      cursor = "${base05}";
      active_border_color = "${base03}";
      inactive_border_color = "${base01}";
      active_tab_background = "${base00}";
      active_tab_foreground = "${base05}";
      inactive_tab_background = "${base01}";
      inactive_tab_foreground = "${base04}";
      tab_bar_background = "${base01}";
      color0 = "${base00}";
      color1 = "${base08}";
      color2 = "${base0B}";
      color3 = "${base0A}";
      color4 = "${base0D}";
      color5 = "${base0E}";
      color6 = "${base0C}";
      color7 = "${base05}";
      color8 = "${base03}";
      color9 = "${base08}";
      color10 = "${base0B}";
      color11 = "${base0A}";
      color12 = "${base0D}";
      color13 = "${base0E}";
      color14 = "${base0C}";
      color15 = "${base07}";
      color16 = "${base09}";
      color17 = "${base0F}";
      color18 = "${base01}";
      color19 = "${base02}";
      color20 = "${base04}";
      color21 = "${base06}";
    };
  };
}
