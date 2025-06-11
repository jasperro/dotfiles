{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    1883
  ];
  networking.firewall.allowedUDPPorts = [
    1883
  ];
  sops.secrets = {
    "mqtt/password" = {
      sopsFile = ../../secrets.yaml;
      owner = "mosquitto";
      group = "mosquitto";
    };
  };
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "0.0.0.0";
        port = 1883;
        users.mosquitto = {
          acl = [ "readwrite #" ];
          passwordFile = config.sops.secrets."mqtt/password".path;
        };
      }
    ];
  };
}
