{ inputs, pkgs, outputs, config, lib, ... }:
let
  lib' = import ./lib.nix { inherit pkgs; };
  papermc = lib'.mkMCServer rec {
    pname = "papermc";
    version = "1.19.3-378";
    url = "https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/378/downloads/paper-1.19.3-378.jar";
    sha256 = "E9BAG6skK6UXpBzvBFrnPoe/bVpz9hW9RaNuFuo/S0I=";
  };
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 19132 ];
  };

  systemd.services.minecraft-server-hacko = {
    restartIfChanged = false;
    wantedBy = lib.mkForce [ ];
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      hacko = {
        enable = true;
        package = papermc;
        jvmOpts = lib'.aikarFlags "4G";
        # openFirewall = true;
        serverProperties = {
          server-port = 25565;
          online-mode = true;
          enable-command-block = true;
          motd = "Welkom bij hacko!";
          enforce-secure-profile = false;
        };
        files = {
          # "plugins/LuckPerms/config.yml" = lib'.toYAMLFile {
          #   split-storage = {
          #     # Don't touch this if you don't want to use split storage!
          #     enabled = true;
          #     methods = {
          #       # These options don't need to be modified if split storage isn't enabled.
          #       user = "h2";
          #       group = "h2";
          #       track = "h2";
          #       uuid = "h2";
          #       log = "h2";
          #     };
          #   };
          # };
        };
        # update with haskellPackages.update-nix-fetchgit
        symlinks = with pkgs;
          {
            "plugins/FastAsyncWorldEdit.jar" = fetchurl {
              url = "https://github.com/IntellectualSites/FastAsyncWorldEdit/releases/download/2.5.0/FastAsyncWorldEdit-Bukkit-2.5.0.jar";
              sha256 = "154prjpf0f57pj8kdqdj0md39g6l53dfsqnr6h7nk60n1q03rsjm";
            };
            "plugins/EssentialsX.jar" = fetchurl {
              url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsX-2.19.7.jar";
              sha256 = "1pnlgnb61psdhc4zb2y5p577ryk4c5kdyk3v0p3nnr0nnsabqldm";
            };
            "plugins/EssentialsXChat.jar" = fetchurl {
              url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsXChat-2.19.7.jar";
              sha256 = "1w86yrld44l0zlkvvykkypygp818h9l5wfn3v6q9z19q9zhsirm1";
            };
            "plugins/EssentialsXSpawn.jar" = fetchurl {
              url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsXSpawn-2.19.7.jar";
              sha256 = "08vlvhw9wmg6bfc2rq4df3ahf7n54vwf9nx7bw3qz27zka0rv3w7";
            };
            "plugins/DecentHolograms.jar" = fetchurl {
              url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.7.9/DecentHolograms-2.7.9.jar";
              sha256 = "1b6yx53xgmr5i1cdq20wi9vpkdm6fjq5ab6smk69m6ib4ngj5rws";
            };
            "plugins/CleanroomGenerator.jar" = fetchurl {
              url = "https://mediafilez.forgecdn.net/files/3596/715/CleanroomGenerator-1.2.1.jar";
              sha256 = "1wpk9hmyjc71jqnzdcinh5jrn2c3ijcnfmh8r5fq1mgnv3zbxla0";
            };
            "plugins/Geyser-Spigot.jar" = fetchurl {
              url = "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/1270/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar";
              sha256 = "0qs8wm85a7z2b9fk0r7wnzlv5p30q2ip281yb92ky6dq2lsivakw";
            };
            "plugins/Floodgate-Spigot.jar" = fetchurl {
              url = "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/74/artifact/spigot/build/libs/floodgate-spigot.jar";
              sha256 = "101plq8vxif6lp39bbba60gqmz3zjfq18wfdcsyx8qq78fj4x1g8";
            };
            "plugins/HeadDB.jar" = fetchurl {
              url = "https://github.com/TheSilentPro/HeadDB/releases/download/5.0.0-rc.2/HeadDB.jar";
              sha256 = "1yj7rmjff7k9mg3fp2f6c601v8i5n8k11s8apg8vbk7mmr1ynhb2";
            };
            "plugins/Multiverse-Core.jar" = fetchurl {
              url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-Core/870/artifact/target/Multiverse-Core-4.3.2-SNAPSHOT.jar";
              sha256 = "1bdfjk956zn7fg7r0i8i4jm7l274dbc300rrvgny33hx6i9cprhw";
            };
            "plugins/Multiverse-Inventories.jar" = fetchurl {
              url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-Inventories/524/artifact/target/Multiverse-Inventories-4.2.4-SNAPSHOT.jar";
              sha256 = "1n2vz65wkd9zl7faya4i4djnyf5qq2csvv3l9fsx9adqixki3pf9";
            };
            "plugins/Multiverse-SignPortals.jar" = fetchurl {
              url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-SignPortals/771/artifact/target/Multiverse-SignPortals-4.2.1-SNAPSHOT.jar";
              sha256 = "0h28l8d4zg1w03vcaxgafij83bjdz1bk4mnh5zxmrwnjsykk6xwq";
            };
            "plugins/Multiverse-NetherPortals.jar" = fetchurl {
              url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-NetherPortals/808/artifact/target/Multiverse-NetherPortals-4.2.3-SNAPSHOT.jar";
              sha256 = "011hbw2dp15ylkr5zk7g2ab4yg5g8szifx60p79c9v6l79xy4bnp";
            };
            "plugins/Vault.jar" = fetchurl {
              url = "https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar";
              sha256 = "07fhfz7ycdlbmxsri11z02ywkby54g6wi9q0myxzap1syjbyvdd6";
            };
            "plugins/LuckPerms.jar" = fetchurl {
              url = "https://download.luckperms.net/1465/bukkit/loader/LuckPerms-Bukkit-5.4.57.jar";
              sha256 = "0jszqvpa4ypj8fn297pl2pnlkbz2wkpa1kiajj9r5zls9bgsmvad";
            };
          };
      };
    };
  };
}
