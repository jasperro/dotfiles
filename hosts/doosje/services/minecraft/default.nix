{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  sharedMinecraftConfig = import ../../../common/services/minecraft/sharedMinecraftConfig.nix {
    inherit pkgs lib;
  };
in
with lib;
with pkgs;
{
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [
      25565
      19132
    ];
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      hacko = mkMerge [
        sharedMinecraftConfig
        {
          serverProperties = {
            motd = "Welkom bij hacko!";
          };
        }
      ];
      gosigBeta = {
        enable = true;
        autoStart = false;
        package = callPackage stdenvNoCC.mkDerivation {
          pname = "minecraft-server";
          version = "b1.7.3";

          src = "${
            (fetchurl {
              url = "https://files.betacraft.uk/server-archive/beta/b1.7.3.jar";
              sha1 = "2F90DC1CB5CA7E9D71786801B307390A67FCF954";
            })
          }";

          preferLocalBuild = true;

          installPhase = ''
            mkdir -p $out/bin $out/lib/minecraft
            cp -v $src $out/lib/minecraft/server.jar

            cat > $out/bin/minecraft-server << EOF
            #!/bin/sh
            exec ${jre8_headless}/bin/java \$@ -jar $out/lib/minecraft/server.jar nogui
            EOF

            chmod +x $out/bin/minecraft-server
          '';

          dontUnpack = true;

          passthru = {
            tests = { inherit (nixosTests) minecraft-server; };
            updateScript = ./update.py;
          };

          meta = with lib; {
            description = "Minecraft Server";
            homepage = "https://minecraft.net";
            license = licenses.unfreeRedistributable;
            platforms = platforms.unix;
            maintainers = with maintainers; [ infinidoge ];
            mainProgram = "minecraft-server";
          };
        };
        jvmOpts =
          ((import ../../../common/services/minecraft/aikar-flags.nix) "4G")
          + " -Dhttp.proxyHost=betacraft.uk";
        serverProperties = {
          server-port = 25565;
          online-mode = false;
          motd = "Gosig beta!";
        };
      };
    };
  };
}
