{
  inputs,
  self,
  jdfPath,
  lib,
  ...
}:
{
  flake-file.inputs = {
    impurity.url = "github:outfoxxed/impurity.nix";
  };

  jdf = lib.setAttrByPath jdfPath {
    nixos = {
      imports = [
        inputs.impurity.nixosModules.default
      ];
      impurity.configRoot = self;
    };
    homeManager = {
      impurity.configRoot = self;
      imports = [ inputs.impurity.nixosModules.default ];
    };
  };
}
