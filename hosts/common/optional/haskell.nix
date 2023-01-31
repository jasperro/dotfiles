{ ... }:
{
  nix.settings = {
    substituters = [
      "https://digitallyinduced.cachix.org"
    ];
    trusted-public-keys = [
      "digitallyinduced.cachix.org-1:y+wQvrnxQ+PdEsCt91rmvv39qRCYzEgGQaldK26hCKE="
    ];
  };
}
