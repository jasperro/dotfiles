{ inputs, ... }:
{
  JDF.nixos._.determinate = {
    nixos.imports = [ inputs.determinate.nixosModules.default ];
  };
}
