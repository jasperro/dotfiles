{ inputs, self, ... }:
{
  JDF.nixos._.impurity = {
    nixos = {
      imports = [ inputs.impurity.nixosModules.default ({impurity, ...}: {
        home-manager.extraSpecialArgs = {inherit impurity;};
      }) ];
      impurity.configRoot = self;
    };
    homeManager = {
      impurity.configRoot = self;
      imports = [ inputs.impurity.nixosModules.default ];
    };
  };
}
