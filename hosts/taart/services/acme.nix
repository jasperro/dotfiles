{
  sops.secrets = {
    acme = {
      sopsFile = ../secrets.yaml;
    };
    "albering.nl-acme-credentials" = {
      path = "/var/src/secrets/albering.nl-acme-credentials";
      mode = "0440";
      owner = config.users.users.acme.name;
      group = config.users.groups.acme.name;
    };
  };
  security.acme = {
    defaults = {
      email = config.sops.secrets.acme.email;
      dnsProvider = "cloudflare";
      reloadServices = [ "nginx" ];
    };
    enabled = true;
    acceptTerms = true;
    certs = {
      "*.albering.nl" = {
        credentialsFile = config.sops.secrets.acme."albering.nl-acme-credentials".path;
      };
    };
  };
}
