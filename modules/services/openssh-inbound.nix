{
  JDF.services._.openssh-inbound.nixos = {
    key = "openssh-inbound";
    services.openssh = {
      enable = true;
      ports = [ 2123 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
