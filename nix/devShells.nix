{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = import "${self}/shell.nix" { inherit pkgs; };
    };
}
