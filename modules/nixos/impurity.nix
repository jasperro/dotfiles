{ inputs, self, ... }:
{

  JDF.nixos._.impurity = {
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
