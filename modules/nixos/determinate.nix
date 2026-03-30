{ inputs, ... }:
{
  JDF.nixos._.determinate = {
    nixos.key = "determinate";
    nixos.imports = [ inputs.determinate.nixosModules.default ];
  };
}
