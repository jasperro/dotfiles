{ inputs, pkgs, outputs, config, lib, ... }:
let
  lib' = import ./lib.nix { inherit pkgs; };
  papermc = lib'.mkMCServer rec {
    pname = "papermc";
    version = "1.20.1-466";
    url = "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/62/downloads/paper-1.20.1-62.jar";
    sha256 = "5Y+dpANM3bmJKMWvYhX4J83VQ6cmaZD7ZR65V7fHdQQ=";
  };
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 19132 ];
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      hacko = {
        enable = true;
        autoStart = false;
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
              url = "https://github.com/IntellectualSites/FastAsyncWorldEdit/releases/download/2.6.4/FastAsyncWorldEdit-Bukkit-2.6.4.jar";
              sha256 = "1rww2zq5l6xhy10wpa5f5x9si3wc2c0mh9mgadql5q3xyaz8881i";
            };
            "plugins/EssentialsX.jar" = fetchurl {
              url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.0/EssentialsX-2.20.0.jar";
              sha256 = "1j5vmbj40n4vp8kq88bb6nahsxqzllcbl2jk3g1bxgjhjgxxlm9c";
            };
            "plugins/EssentialsXChat.jar" = fetchurl {
              url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.0/EssentialsXChat-2.20.0.jar";
              sha256 = "10gx00zlicfsjdc9dy0whnvhx85f5i55a1vhzl791kry32anqnh9";
            };
            "plugins/EssentialsXSpawn.jar" = fetchurl {
              url = "https://github.com/EssentialsX/Essentials/releases/download/2.20.0/EssentialsXSpawn-2.20.0.jar";
              sha256 = "03716wgakd58gr4vycsdbcg9n14vi3nfpjymaiaz3nic0p7h6cnz";
            };
            "plugins/DecentHolograms.jar" = fetchurl {
              url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.8.3/DecentHolograms-2.8.3.jar";
              sha256 = "16yc9xzpfqaw4rz559jjsn771j4z1rc9zpfq6yd8c3pdr2igy3wj";
            };
            "plugins/CleanroomGenerator.jar" = fetchurl {
              url = "https://mediafilez.forgecdn.net/files/3596/715/CleanroomGenerator-1.2.1.jar";
              sha256 = "1wpk9hmyjc71jqnzdcinh5jrn2c3ijcnfmh8r5fq1mgnv3zbxla0";
            };
            "plugins/Geyser-Spigot.jar" = fetchurl {
              url = "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/1441/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar";
              sha256 = "1mnygdx6x411zg5a278naqg0d0vpbvdibx41rl90hxl59swllvzz";
            };
            "plugins/Floodgate-Spigot.jar" = fetchurl {
              url = "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/88/artifact/spigot/build/libs/floodgate-spigot.jar";
              sha256 = "1p9p4rrbq7aj0n1c1fszxkdiyk8zrx63y6fw6jlqn7nkrb31mn9p";
            };
            "plugins/HeadDB.jar" = fetchurl {
              url = "https://github.com/TheSilentPro/HeadDB/releases/download/5.0.0-rc.6/HeadDB.jar";
              sha256 = "1xdg41kw8qxh8y8rl08d8vnm8cb1diqmal7w3xvikmpcvgr6z3rp";
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
              url = "https://download.luckperms.net/1512/bukkit/loader/LuckPerms-Bukkit-5.4.98.jar";
              sha256 = "1iirxigl1x3la169iv3xslpnq87zx1r0cf8di05l76vcwjpnpr47";
            };
          };
      };
    };
  };
}
