{ den, __findFile, ... }:
{
  den.aspects."jasperro@tinkpet-wsl" = {
    includes = [
      <JDF/stylix>

      <JDF/users/jasperro/git>
      <JDF/users/jasperro/cli>

      <JDF/users/jasperro/editors/nixvim>

      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    nixos.users.groups.jasperro.gid = 1000;

    user = {
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      group = "jasperro";
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
      ];

      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };

    homeManager =
      { pkgs, ... }:
      {
        key = "jasperro-tinkpet-wsl";
        stylix = {
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        };
      };
  };
}
