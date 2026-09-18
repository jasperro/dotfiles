{
  inputs,
  jdfPath,
  lib,
  ...
}:
{
  flake-file.inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  jdf = lib.setAttrByPath jdfPath {
    nixos.imports = [ inputs.determinate.nixosModules.default ];
  };
}
