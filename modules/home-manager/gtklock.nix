{
  config,
  pkgs,
  lib,
  ...
}:
with lib;

let
  cfg = config.programs.gtklock;
in
{
  options.programs.gtklock = {
    enable = mkEnableOption "gtklock";

    settings = mkOption {
      default = { };
      description = "GTKLock Settings";
      type = (pkgs.formats.ini { }).type;
    };

    package = mkPackageOption pkgs "gtklock" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."gtklock/config.ini" = lib.mkIf (cfg.settings != { }) {
      text = lib.generators.toINI { } cfg.settings;
    };
  };
}
