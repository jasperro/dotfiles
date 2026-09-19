{
  den,
  jdf,
  ...
}:
{
  den.aspects."jasperro@superlaptop" = {
    includes = [
      jdf.jasperro._.git
      jdf.jasperro._.cli

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    user = {
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      group = "wiktorine";
      extraGroups = [
        "wheel"
        "http"
        "docker"
        "podman"
        "video"
        "uucp"
        "dialout"
        "kvm"
        "audio"
        # For waypipe
        "input"
        "uinput"
      ];
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          waypipe
        ];
      };
  };
}
