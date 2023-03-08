{ inputs, pkgs, outputs, config, lib, ... }:
let
  lib' = import ./lib.nix { inherit pkgs; };
  papermc = lib'.mkMCServer rec {
    pname = "papermc";
    version = "1.19.3-445";
    url = "https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/445/downloads/paper-1.19.3-445.jar";
    sha256 = "EJ1+g4QCwEWltXESPqd5Hc+5nRy4WKuXse3wm4PuSfo=";
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
              url = "https://github.com/IntellectualSites/FastAsyncWorldEdit/releases/download/2.5.2/FastAsyncWorldEdit-Bukkit-2.5.2.jar";
              sha256 = "06jzgfy10bdr03ny8d9cvv4hi1nq0mhmbbmsyqqz3mckpc7xhb9z";
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
              url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.7.11/DecentHolograms-2.7.11.jar";
              sha256 = "18k1mxlm1qr2pw2jfsjd63a68kcvcm0kzkp0w3y1dgcanp87ik66";
            };
            "plugins/CleanroomGenerator.jar" = fetchurl {
              url = "https://mediafilez.forgecdn.net/files/3596/715/CleanroomGenerator-1.2.1.jar";
              sha256 = "1wpk9hmyjc71jqnzdcinh5jrn2c3ijcnfmh8r5fq1mgnv3zbxla0";
            };
            "plugins/Geyser-Spigot.jar" = fetchurl {
              url = "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/1320/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar";
              sha256 = "0mp4awnzj6y7kzhnmdwkfk8fdkb7aa4370wmp0mak5009v8r9hc3";
            };
            "plugins/Floodgate-Spigot.jar" = fetchurl {
              url = "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/77/artifact/spigot/build/libs/floodgate-spigot.jar";
              sha256 = "0x3im039sc972niad0kiywh9kdm21mc7wwd46c3qslg82123rc9j";
            };
            "plugins/HeadDB.jar" = fetchurl {
              url = "https://github.com/TheSilentPro/HeadDB/releases/download/5.0.0-rc.3/HeadDB.jar";
              sha256 = "0grmy1gzhayz5p73wpgk9mrvl9kxl16y9xscxfmv0zmivxfhnhg6";
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
              url = "https://download.luckperms.net/1475/bukkit/loader/LuckPerms-Bukkit-5.4.64.jar";
              sha256 = "1jk03xnmbngl59w924bx3qqhz81cbll3l6bzv71s56b3kmlm9dmp";
            };
          };
      };
    };
  };
}
