{ ... }:
{
  JDF.hosts._.taart = {
    includes = [
      <JDF/services/openssh-inbound>
    ];
    nixos = {
      imports = [
        ./_services/home-automation
        ./_services/acme.nix
        ./_services/nginx.nix
        ./_services/vaultwarden.nix
      ];
    };
  };
}
