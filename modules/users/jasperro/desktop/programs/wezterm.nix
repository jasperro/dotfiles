{
  JDF.users._.jasperro._.desktop._.programs._.wezterm.homeManager = {
    key = "jasperro-wezterm";
    home = {
      sessionVariables = {
        TERMINAL = "wezterm";
      };
    };
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
    };
    stylix.targets.wezterm.enable = true;
  };
}
