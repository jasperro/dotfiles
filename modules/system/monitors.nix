{
  lib,
  ...
}:
let
  monitorSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        example = "DP-1";
      };
      primary = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      noBar = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      width = lib.mkOption {
        type = lib.types.int;
        example = 1920;
      };
      height = lib.mkOption {
        type = lib.types.int;
        example = 1080;
      };
      refreshRate = lib.mkOption {
        type = lib.types.float;
        default = 60;
      };
      x = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      y = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      workspace = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      vrr = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      scale = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
      };
    };
  };
in
{
  den.schema.conf.options.monitors = lib.mkOption {
    type = lib.types.listOf monitorSubmodule;
    default = [ ];
    description = "Configured display monitors.";
  };
}
