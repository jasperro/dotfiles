{
  config,
  impurity,
  pkgs,
  inputs,
  ...
}:
let
  dataDir = "/var/lib/zigbee2mqtt";
  frontendPort = 1919;
  devicesFile = impurity.link ./devices.yaml;
  groupsFile = impurity.link ./groups.yaml;
in
{
  users.users.zigbee2mqtt.extraGroups = [
    # Because I forgot to map the group, change to dialout only!
    "lp"
    "dialout"
  ];
  sops.secrets = {
    zigbee2mqtt = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      path = "${dataDir}/secret.yaml";
      mode = "0440";
      owner = config.users.users.zigbee2mqtt.name;
      group = config.users.groups.zigbee2mqtt.name;
    };
  };
  networking.firewall.allowedTCPPorts = [ frontendPort ];

  # Some stupid stuff, not sure if I want these modifiable or not.
  systemd.services.zigbee2mqtt.serviceConfig.ExecStartPre = [
    "${pkgs.coreutils}/bin/cp --no-preserve=mode ${devicesFile} ${dataDir}/devices.yaml"
    "${pkgs.coreutils}/bin/cp --no-preserve=mode ${groupsFile} ${dataDir}/groups.yaml"
  ];

  services.zigbee2mqtt = {
    # package = pkgs.zigbee2mqtt_2;
    dataDir = dataDir;
    enable = true;
    settings = {
      homeassistant = {
        enabled = true;
        experimental_event_entities = true;
        legacy_action_sensor = true;
      };
      permit_join = false;
      serial = {
        adapter = "zstack";
        port = "/dev/ttyUSB0";
        disable_led = true;
      };
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://localhost";
        user = "!secret.yaml user";
        password = "!secret.yaml pass";
        client_id = "ZIGB_MQTT";
        keepalive = 60;
        reject_unauthorized = true;
        version = 5;
      };
      groups = "groups.yaml";
      devices = "devices.yaml";
      frontend = {
        port = frontendPort;
        host = "0.0.0.0";
        auth_token = "!secret.yaml auth_token";
      };
      advanced = {
        cache_state_send_on_startup = false;
        channel = 25;
        log_level = "info";
        transmit_power = 9;
        network_key = "!secret.yaml network_key";
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
