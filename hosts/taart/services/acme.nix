{ config, inputs, ... }:
{
  sops.secrets = {
    "albering.nl-acme-credentials" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      path = "/var/src/secrets/albering.nl-acme-credentials";
      mode = "0440";
      owner = config.users.users.acme.name;
      group = config.users.groups.acme.name;
    };
  };
  security.acme = {
    defaults = {
      email = "jasper.albering@gmail.com";
      dnsProvider = "cloudflare";
      reloadServices = [ "nginx" ];
    };
    acceptTerms = true;
    certs = {
      "albering" = {
        domain = "*.albering.nl";
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets."albering.nl-acme-credentials".path;
        };
      };
    };
  };
}
