{ den, __findFile, ... }:
{
  den.aspects.jasperro-koekie = {
    includes = [
      <JDF/users/jasperro/git>
      <JDF/users/jasperro/cli>

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    # nixos.users.groups.jasperro.gid = 1000;

    user = {
      uid = 1002;
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
        key = "jasperro-koekie";
        home.packages = with pkgs; [
          waypipe
        ];
      };
  };
}
