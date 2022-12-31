{ inputs, pkgs, outputs, config, ... }:
let
  papermc = pkgs.callPackage ./pkgs/papermc.nix { };
  toTOMLFile = expr: pkgs.runCommand "expr.toml" { } ''
    ${pkgs.remarshal}/bin/remarshal \
    -i ${builtins.toFile "expr" (builtins.toJSON expr)} \
    -o $out -if json -of toml
  '';
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      hacko = {
        enable = false;
        package = papermc;
        jvmOpts = "-Xmx4G -Xms4G";
        openFirewall = true;
        serverProperties = {
          server-port = 25565;
          online-mode = false;
        };
        symlinks = {
          plugins = pkgs.linkFarm "plugins"

            [
              { name = "FastAsyncWorldEdit.jar"; path = inputs.FAWE; }
              { name = "EssentialsX.jar"; path = inputs.EssentialsX; }
              { name = "EssentialsXChat.jar"; path = inputs.EssentialsXChat; }
              { name = "EssentialsXSpawn.jar"; path = inputs.EssentialsXSpawn; }
              { name = "DecentHolograms.jar"; path = inputs.DecentHolograms; }
              { name = "CleanroomGenerator.jar"; path = inputs.CleanroomGenerator; }
              { name = "Geyser-Spigot.jar"; path = inputs.Geyser; }
              { name = "Floodgate-Spigot.jar"; path = inputs.Floodgate; }
              { name = "HeadDB.jar"; path = inputs.HeadDB; }
              { name = "Multiverse-Core.jar"; path = inputs.MultiverseCore; }
              { name = "Multiverse-Inventories.jar"; path = inputs.MultiverseInventories; }
              { name = "Multiverse-SignPortals.jar"; path = inputs.MultiverseSignPortals; }
              { name = "Multiverse-NetherPortals.jar"; path = inputs.MultiverseNetherPortals; }
              { name = "Vault.jar"; path = inputs.Vault; }
            ];

        };
      };

    };
  };
}
