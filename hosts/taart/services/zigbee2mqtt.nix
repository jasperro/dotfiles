{
  sops.secrets = {
    mqtt = {
      sopsFile = ../secrets.yaml;
    };
    z2m = {
      sopsFile = ../secrets.yaml;
    };
  };
  services.zigbee2mqtt = {
    enable = true;
    settings =
      {
        homeassistant = true;
        permit_join = false;
        serial = {
          port = "/dev/ttyUSB0";
          disable_led = true;
        };
        mqtt = {
          base_topic = "zigbee2mqtt";
          server = "mqtt://localhost";
          user = config.sops.secrets.mqtt.user;
          password = config.sops.secrets.mqtt.pass;
          client_id = "ZIGB_MQTT";
          keepalive = 60;
          reject_unauthorized = true;
          version = 5;
        };
        groups = "groups.yaml";
        devices = "devices.yaml";
        frontend = {
          port = 1920;
          host = "0.0.0.0";
          auth_token = config.sops.secrets.z2m.auth_token;
        };
        advanced = {
          cache_state_send_on_startup = false;
          channel = 25;
          log_level = "info";
          transmit_power = 9;
          network_key = config.sops.secrets.z2m.network_key;
        };
        device_options = {
          retain = true;
          homeassistant = {
            tamper = {
              payload_on = false;
              payload_off = true;
            };
          };
        };
        ota = {
          update_check_interval = 86400;
          disable_automatic_update_check = true;
        };
      };
  };

}
