{ impurity, ... }:
{
  programs.eww = {
    enable = true;
    configDir = impurity.link ./config;
    enableZshIntegration = true;
  };
}
