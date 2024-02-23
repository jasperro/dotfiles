{ inputs, pkgs, outputs, config, lib, ... }:
let
  sharedMinecraftConfig = import ../../../common/services/minecraft/sharedMinecraftConfig.nix { inherit pkgs lib; };
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
      wiktor = sharedMinecraftConfig // {
        serverProperties = {
          motd = "Welkom bij Wiktor's Minecraft server!";
        };
      };
    };
  };
}
