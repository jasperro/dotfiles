{
  services.postgresql = {
    enable = true;
    dataDir = "/var/lib/postgresql";
    ensureDatabases = [ "hass" ];
    ensureUsers = [
      {
        name = "hass";
        ensurePermissions = {
          "DATABASE hass" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
