{ inputs, lib, config, ... }:
let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.sshKeyPaths = map getKeyPath keys;
  };

  nix.settings = {
    substituters = [ "https://mic92.cachix.org" ];
    trusted-public-keys = [ "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ=" ];
  };
}
