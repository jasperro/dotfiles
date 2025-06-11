{ config, ... }:
{
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
        users = {
          mosquitto = {
            passwordFile = config.sops.secrets."mqtt/password".path;
          };
        };
      }
    ];
  };
}
