{ inputs, ... }:
{
  flake-file.inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  JDF.nixos._.determinate = {
    nixos.key = "determinate";
    nixos.imports = [ inputs.determinate.nixosModules.default ];
  };
}
