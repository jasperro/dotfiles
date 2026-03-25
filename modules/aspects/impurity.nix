{ inputs, self, ... }:
{
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
