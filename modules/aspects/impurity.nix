{ inputs, self, ... }:
{
  flake-file.inputs = {
    impurity.url = "github:outfoxxed/impurity.nix";
  };

  den.aspects.impurity = {
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
