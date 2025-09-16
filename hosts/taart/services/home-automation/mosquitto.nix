{ config, inputs, ... }:
let
  port = 1883;
in
{
  networking.firewall.allowedTCPPorts = [
    port
  ];
  networking.firewall.allowedUDPPorts = [
    port
  ];
  sops.secrets = {
    "mqtt/password" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      owner = "mosquitto";
      group = "mosquitto";
      mode = "0440";
    };
  };
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "0.0.0.0";
        port = port;
        users.mosquitto = {
          acl = [ "readwrite #" ];
          passwordFile = config.sops.secrets."mqtt/password".path;
        };
      }
    ];
  };
}
