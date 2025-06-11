{ pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      paho-mqtt
      requests
      influxdb
      influxdb-client
    ]
  );

  grottSource = pkgs.fetchFromGitHub {
    owner = "johanmeijer";
    repo = "grott";
    rev = "fb52e2d4ff3065f60db45a7c2c82f2ad7e9f8463";
    hash = "sha256-q521T9KZz/QhbSOyNAFsftUZeMLaW/pjmGCJgk2j0Rs=";
  };
in
pkgs.dockerTools.buildImage {
  name = "grott";
  tag = "latest";

  config = {
    Cmd = [
      "${pythonEnv.interpreter}"
      "-u"
      "/app/grott.py"
      "-v"
    ];
    WorkingDir = "/app";
    Env = [
      "LANG=en_US.UTF-8"
      "LC_ALL=en_US.UTF-8"
    ];
  };

  copyToRoot = pkgs.buildEnv {
    name = "grott-root";
    paths = [ pythonEnv ];
    postBuild = ''
      mkdir -p $out/app
      cp ${grottSource}/grott.py $out/app/
      cp ${grottSource}/grottconf.py $out/app/
      cp ${grottSource}/grottdata.py $out/app/
      cp ${grottSource}/grottproxy.py $out/app/
      cp ${grottSource}/grottsniffer.py $out/app/
    '';
  };
}
