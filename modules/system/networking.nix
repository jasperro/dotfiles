# This should be used on all hosts that are directly connected to LAN
# (e.g. not a container or WSL that are networked separately)
{
  den,
  lib,
  jdfPath,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    includes = [
      den.batteries.hostname
    ];
    nixos = {
      networking.useNetworkd = true;
      networking.firewall.enable = true;

      services.resolved.enable = true;

      services.timesyncd.enable = true;

      services.avahi = {
        nssmdns4 = true;
        #nssmdns6 = true;
        enable = true;
        settings = {
          server = {
            use-ipv4 = true;
            use-ipv6 = true;
          };
          publish = {
            publish-addresses = true;
            publish-workstation = true;
            publish-domain = true;
            publish-hinfo = true;
          };
        };
        openFirewall = true;
      };

      # Some changes that fix some network stuff
      # Copied from https://github.com/nix-community/srvos/blob/main/nixos/common/networking.nix

      # The notion of "online" is a broken concept
      # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
      systemd.services.NetworkManager-wait-online.enable = false;
      systemd.network.wait-online.enable = false;

      # FIXME: Maybe upstream?
      # Do not take down the network for too long when upgrading,
      # This also prevents failures of services that are restarted instead of stopped.
      # It will use `systemctl restart` rather than stopping it with `systemctl stop`
      # followed by a delayed `systemctl start`.
      systemd.services.systemd-networkd.stopIfChanged = false;
      # Services that are only restarted might be not able to resolve when resolved is stopped before
      systemd.services.systemd-resolved.stopIfChanged = false;
    };
  };
}
