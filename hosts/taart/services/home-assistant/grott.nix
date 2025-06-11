{ config, ... }:
{
  imports = [ ./mosquitto.nix ];
  sops.templates."grott-env" = {
    content = ''
      gmqttpassword=${config.sops.placeholder."mqtt/password"}
    '';
  };
  networking.firewall.allowedTCPPorts = [
    5279
  ];
  networking.firewall.allowedUDPPorts = [
    5279
  ];
  virtualisation.oci-containers.containers.grott = {
    image = "ledidobe/grott";
    autoStart = true;

    ports = [
      "5279:5279"
    ];

    environment = {
      gmode = "proxy";
      # To block commands from outside (to change inverter and shine devices settings)
      gblockcmd = "True";
      gnomqtt = "False";
      gmqttip = "localhost";
      gmqttauth = "True";
      gmqttuser = "mosquitto";
      # from sops
      # gmqttpassword = "";
      gpvoutput = "False";
      # gpvapikey = "yourapikey";
      # gpvsystemid1 = "12345";
      ginflux = "False";
      ginflux2 = "False";
      # gifdbname = "grottdb";
      # gifip = "localhost";
      # gifport = "8086";
      # gifuser = "grott";
      # gigpassword = "growatt2020";
      # giftoken = "influx_token";
      # giforg = "grottorg";
      # gifbucket = "grottdb";
      gextension = "false";
      gextname = "grottext";
      gextvar = ''{"ip": "192.168.0.47", "port": "8000"}'';
      TZ = "Europe/Amsterdam";
    };

    environmentFiles = [
      config.sops.templates.grott-env.path
    ];

    # Optional volume mounting if needed
    # volumes = [
    #   "/opt/grott/grottstub.ini:/app/grott.ini"
    #   "/opt/grott/grottstub.py:/app/grottext.py"
    # ];
  };
}
