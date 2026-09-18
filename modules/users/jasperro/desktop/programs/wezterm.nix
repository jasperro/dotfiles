{ lib, jdfPath, ... }: {
  jdf = lib.setAttrByPath jdfPath {
    homeManager = {
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
  };
}
