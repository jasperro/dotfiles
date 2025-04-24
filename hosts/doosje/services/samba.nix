{ ... }:
{
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];
  networking.firewall.allowPing = true;
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = DOOSJE
      server role = standalone server
      server string = smbnix
      netbios name = smbnix
      security = user 
      hosts allow = 192.168.1.0/24, 127.0.0.1, localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      ntlm auth = yes
    '';
    # shares = {
    #   public = {
    #     path = "/abs/path/";
    #     browseable = "yes";
    #     public = "yes";
    #     "read only" = "yes";
    #     "guest ok" = "yes";
    #     "create mask" = "0644";
    #     "directory mask" = "0755";
    #     "force user" = "jasperro";
    #     "force group" = "jasperro";
    #   };
    # };
  };

  # environment.systemPackages = with pkgs; [
  #   samba
  #   cifs-utils
  #   kio-fuse
  #   libsForQt5.kio
  #   libsForQt5.kio-extras
  #   libsForQt5.dolphin-plugins
  #   libsForQt5.kdenetwork-filesharing
  # ];

  # users.groups.usershares = { };
}
