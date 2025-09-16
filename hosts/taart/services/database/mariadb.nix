{ pkgs, ... }:
let
  port = 3306;
in
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mariadb";
    ensureDatabases = [ "homeassistant" ];
    ensureUsers = [
      {
        name = "hass";
        ensurePermissions = {
          "homeassistant.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
