{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # Custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = import "${self}/pkgs" { inherit pkgs; };
    };
}
