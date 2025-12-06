{ ... }:
{
  imports = [
    ../../common/services/openssh-inbound.nix
    ./home-automation
    ./acme.nix
    ./nginx.nix
    ./vaultwarden.nix
  ];
}
