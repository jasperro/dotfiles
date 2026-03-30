{
  JDF.services._.sunshine.nixos = {
    key = "sunshine";
    services.sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
      autoStart = true;
    };
  };
}
