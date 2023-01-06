{ inputs, pkgs, outputs, config, lib, ... }:
let
  lib' = import ./lib.nix { inherit pkgs; };
  papermc = lib'.mkMCServer rec {
    pname = "papermc";
    version = "1.19.3-370";
    url = "https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/370/downloads/paper-1.19.3-370.jar";
    sha256 = "MG68uu91fYn7iq2bxu2hAVA5Jo0+muNOG/dTFk1kgq0=";
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
        symlinks = {
          "plugins/FastAsyncWorldEdit.jar" = inputs.FAWE;
          "plugins/EssentialsX.jar" = inputs.EssentialsX;
          "plugins/EssentialsXChat.jar" = inputs.EssentialsXChat;
          "plugins/EssentialsXSpawn.jar" = inputs.EssentialsXSpawn;
          "plugins/DecentHolograms.jar" = inputs.DecentHolograms;
          "plugins/CleanroomGenerator.jar" = inputs.CleanroomGenerator;
          "plugins/Geyser-Spigot.jar" = inputs.Geyser;
          "plugins/Floodgate-Spigot.jar" = inputs.Floodgate;
          "plugins/HeadDB.jar" = inputs.HeadDB;
          "plugins/Multiverse-Core.jar" = inputs.MultiverseCore;
          "plugins/Multiverse-Inventories.jar" = inputs.MultiverseInventories;
          "plugins/Multiverse-SignPortals.jar" = inputs.MultiverseSignPortals;
          "plugins/Multiverse-NetherPortals.jar" = inputs.MultiverseNetherPortals;
          "plugins/Vault.jar" = inputs.Vault;
          "plugins/LuckPerms.jar" = inputs.LuckPerms;
        };
      };
    };
  };
}
