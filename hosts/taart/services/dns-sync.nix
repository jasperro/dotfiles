{ jdf, ... }: {
  jdf.hosts._.taart._.services._.dns-sync.nixos =
    {
      pkgs,
      host,
      lib,
      config,
      ...
    }:
    let
      netCfg = host.settings.services.network;

      mkCloudflareRecords =
        domain: devices:
        lib.listToAttrs (
          lib.concatLists (
            lib.mapAttrsToList (
              ip: subdomains:
              map (
                name:
                lib.nameValuePair "dns_${name}" {
                  zone_id = "\${data.cloudflare_zone.domain.id}";
                  name = "${name}.${domain}";
                  value = ip;
                  type = "A";
                  proxied = false; # Grey cloud
                  ttl = 1; # Auto TTL
                }
              ) subdomains
            ) devices
          )
        );

      opentofuConfig = {
        terraform = {
          required_providers.cloudflare = {
            source = "cloudflare/cloudflare";
            version = "~> 4.0";
          };
        };

        data.cloudflare_zone.domain = {
          name = netCfg.baseDomain;
        };

        resource.cloudflare_record = mkCloudflareRecords netCfg.baseDomain netCfg.lanDevices;
      };

      opentofuJson = pkgs.writeText "main.tf.json" (builtins.toJSON opentofuConfig);
      stateDir = "/var/lib/cloudflare-dns-tf";
    in
    {
      systemd.tmpfiles.rules = [
        "d ${stateDir} 0750 ${config.users.users.acme.name} ${config.users.groups.acme.name} -"
        "L+ ${stateDir}/main.tf.json - - - - ${opentofuJson}"
      ];

      systemd.services.sync-cloudflare-dns = {
        description = "Sync LAN DNS A records to Cloudflare via OpenTofu";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          User = config.users.users.acme.name;
          Group = config.users.groups.acme.name;
          StateDirectory = "cloudflare-dns-tf";
          WorkingDirectory = stateDir;
        };

        script = ''
          SECRET_PATH="${config.sops.secrets."albering.nl-acme-credentials".path}"

          if [ ! -f "$SECRET_PATH" ]; then
            echo "SOPS secret file not found at $SECRET_PATH. Skipping Cloudflare sync."
            exit 0
          fi

          export CLOUDFLARE_API_TOKEN="$(cat "$SECRET_PATH" | tr -d '\n\r')"

          if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
            echo "Cloudflare token is empty. Skipping sync."
            exit 0
          fi

          ${pkgs.opentofu}/bin/tofu init -input=false
          ${pkgs.opentofu}/bin/tofu apply -input=false -auto-approve
        '';
      };
    };
}
