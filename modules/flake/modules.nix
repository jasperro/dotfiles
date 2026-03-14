{ self, ... }:
{
  flake = _: {
    # Reusable nixos modules
    nixosModules = import "${self}/modules/nixos";

    # Reusable home-manager modules
    homeModules = import "${self}/modules/home-manager";
  };
}
