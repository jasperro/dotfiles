{
  config,
  oci-images,
  inputs,
  pkgs,
  ...
}:
let
  mqttBrokerURL = "127.0.0.1:1883";
in
{
  sops.secrets = {
    "hame/username" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      mode = "0440";
    };
    "hame/password" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      mode = "0440";
    };
    "hame/device0/mac" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      mode = "0440";
    };
    "hame/device0/id" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      mode = "0440";
    };
  };
  sops.templates."hame-config" =
    let
      hameConfig = {
        broker_url = "mqtt://${config.sops.placeholder."mqtt/username"}:${
          config.sops.placeholder."mqtt/password"
        }@${mqttBrokerURL}";
        inverse_forwarding = true;
        default_broker_id = "hame-2024";
        username = "${config.sops.placeholder."hame/username"}";
        password = "${config.sops.placeholder."hame/password"}";
        devices = [
          {
            device_id = "${config.sops.placeholder."hame/device0/id"}";
            mac = "${config.sops.placeholder."hame/device0/mac"}";
            type = "HMG-50";
            version = 153;
          }
          # {
          #   device_id = "${config.sops.placeholder."hame/device1/id"}";
          #   mac = "${config.sops.placeholder."hame/device1/mac"}";
          #   type = "HME-3";
          #   version = 117;
          # }
        ];
      };
    in

    {
      content = builtins.toJSON hameConfig;
      mode = "0440";
    };
  sops.templates."hm2mqtt-env" = {
    content = ''
      MQTT_USERNAME=${config.sops.placeholder."mqtt/username"}
      MQTT_PASSWORD=${config.sops.placeholder."mqtt/password"}
      DEVICE_0=HMG-50:${config.sops.placeholder."hame/device0/mac"}
    '';
    mode = "0440";
  };
  virtualisation.oci-containers.containers.hm2mqtt = {
    inherit (oci-images.hm2mqtt) image imageFile;
    autoStart = true;
    environment = {
      MQTT_BROKER_URL = "mqtt://${mqttBrokerURL}";
      MQTT_POLLING_INTERVAL = "30";
      MQTT_RESPONSE_TIMEOUT = "15";
      POLL_CELL_DATA = "false";
      POLL_EXTRA_BATTERY_DATA = "false";
      POLL_CALIBRATION_DATA = "false";
    };
    extraOptions = [
      "--network=host"
    ];
    environmentFiles = [
      config.sops.templates.hm2mqtt-env.path
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/hame-relay/config 0750 root root -"
    "f /var/lib/hame-relay/config/config.json 0640 root root -"
  ];

  systemd.services.podman-hame-relay = {
    serviceConfig = {
      ExecStartPre = [
        ''
          ${pkgs.coreutils}/bin/mkdir -p /var/lib/hame-relay/config
        ''
        ''
          ${pkgs.coreutils}/bin/cp --no-preserve=mode ${config.sops.templates.hame-config.path} /var/lib/hame-relay/config/config.json
        ''
      ];
    };
  };

  virtualisation.oci-containers.containers.hame-relay = {
    inherit (oci-images.hame-relay) image imageFile;
    autoStart = true;
    dependsOn = [ "hm2mqtt" ];
    volumes = [
      "/var/lib/hame-relay/config:/app/config"
    ];
    environment = {
      LOG_LEVEL = "debug";
    };
    extraOptions = [
      "--network=host"
    ];
  };
}
