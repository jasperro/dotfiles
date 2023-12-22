# This should be used on all hosts that are directly connected to LAN
# (e.g. not a container or WSL that are networked separately)
{
  services.resolved.enable = true;

  services.timesyncd.enable = true;

  services.avahi = {
    nssmdns = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      domain = true;
      hinfo = true;
      userServices = true;
    };
    openFirewall = true;
  };
}
