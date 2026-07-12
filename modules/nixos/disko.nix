{ inputs, ... }:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
  };

  imports = [ inputs.disko.flakeModules.default ];

  JDF.nixos._.disko.nixos =
    { pkgs, ... }:
    {
      key = "disko";
      imports = [ inputs.disko.nixosModules.default ];
    };
}
