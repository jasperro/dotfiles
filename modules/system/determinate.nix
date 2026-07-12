{ inputs, ... }:
{
  flake-file.inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  JDF.system._.determinate = {
    nixos.imports = [ inputs.determinate.nixosModules.default ];
  };
}
