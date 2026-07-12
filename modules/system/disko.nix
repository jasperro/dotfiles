{ inputs, ... }:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
  };

  imports = [ inputs.disko.flakeModules.default ];

  JDF.system._.disko.nixos =
    { pkgs, ... }:
    {
      imports = [ inputs.disko.nixosModules.default ];
    };
}
