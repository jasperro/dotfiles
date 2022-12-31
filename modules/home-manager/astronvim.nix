{ config
, pkgs
, lib
, inputs
, ...
}:
with lib; let
  cfg = config.astronvim;
in
{
  options = {
    astronvim = {
      enable = mkOption {
        default = false;
        description = "Enable AstroNVim";
	type = types.bool;
      };

      userConfig = mkOption {
        default = null;
        description = "AstroNVim User Config";
        type = with types; nullOr path;
      };
    };
  };
  config = mkIf (cfg.enable) {
    home = {
      file = {
        ".config/nvim" = {
          recursive = true;
          source = inputs.astronvim;
        };
        ".config/nvim/lua/user" = mkIf (cfg.userConfig != null) {
          recursive = true;
          source = cfg.userConfig;
        };
      };
    };
  };
}
