{
  den,
  jdf,
  lib,
  ...
}:
{
  den.schema.host.imports = [
    {
      options.settings = lib.mkOption {
        type = import ./_settings-type.nix { inherit den jdf lib; };
        default = { };
        description = "Per-aspect typed settings";
      };
    }
  ];

  den.reservedKeys = [ "settings" ];
}
