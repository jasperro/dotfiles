{
  JDF.services._.sunshine.nixos = {
    services.sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
      autoStart = true;
    };
  };
}
