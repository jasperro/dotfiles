{ inputs, ... }:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
  };

  imports = [ inputs.disko.flakeModules.default ];

  jdf.system._.disko.nixos =
    { pkgs, ... }:
    {
      imports = [ inputs.disko.nixosModules.default ];
    };
}
