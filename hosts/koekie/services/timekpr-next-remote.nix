{ pkgs, ... }:

let

  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      fabric
      paramiko
      flask
      gotify
      humanize
    ]
  );

  timekprRemoteSource = pkgs.fetchFromGitHub {
    owner = "mrjones-plip";
    repo = "timekpr-next-remote";
    rev = "4cf6503763f10839cc9786026b3d26176932f4aa";
    hash = "sha256-q521T9KZz/QhbSOyNAFsftUZeMLaW/pjmGCJgk2j0Rs=";
  };

  imageFile = pkgs.dockerTools.buildImage {
    name = "timekpr-next-remote";
    tag = "latest";

    config = {
      Cmd = [
        "${pythonEnv.interpreter}"
        "-u"
        "/app/app.py"
      ];
      ExposedPorts = {
        "8080/tcp" = { };
      };
      WorkingDir = "/app";
    };
  };
in
{
  networking.firewall.allowedTCPPorts = [
    8080
  ];
  networking.firewall.allowedUDPPorts = [
    8080
  ];

  virtualisation.oci-containers.containers.timekpr-next-remote = {
    image = "timekpr-next-remote:latest";
    inherit imageFile;
    autoStart = true;

    ports = [
      "8080:8080"
    ];

    environment.TZ = "Europe/Amsterdam";

    volumes = [
      "${/var/lib/timekpr-next-remote/conf.py}:/app/conf.py"
    ];

    copyToRoot = pkgs.buildEnv {
      name = "timekpr-next-remote-root";
      paths = [ pythonEnv ];
      postBuild = ''
        cp ${timekprRemoteSource} $out/app
      '';
    };
  };
}
