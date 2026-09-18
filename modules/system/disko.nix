{
  inputs,
  jdfPath,
  lib,
  ...
}:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
  };

  imports = [ inputs.disko.flakeModules.default ];

  jdf = lib.setAttrByPath jdfPath {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.disko.nixosModules.default ];
      };
  };
}
