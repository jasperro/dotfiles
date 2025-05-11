{ lib, impurity, ... }:
{
  programs.vscode.enable = true;
  stylix.targets.vscode.enable = true;
  # Disable stylix settings for vscode, as I want these mutable/impurity-capable.
  programs.vscode.profiles.default.userSettings = lib.mkForce { };

  xdg.configFile = {
    "Code/User/settings.json".source = impurity.link ./userSettings.json;
  };
}
