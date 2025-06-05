{ pkgs, ... }:
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mariadb";
    ensureDatabases = [ "hass" ];
    ensureUsers = [
      {
        name = "hass";
        ensurePermissions = {
          "hass.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
