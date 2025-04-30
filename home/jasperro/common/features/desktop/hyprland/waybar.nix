{
  config,
  pkgs,
  ...
}:
let
  # Dependencies
  cat = "${pkgs.coreutils}/bin/cat";
  cut = "${pkgs.coreutils}/bin/cut";
  grep = "${pkgs.gnugrep}/bin/grep";
  jq = "${pkgs.jq}/bin/jq";
  gamemoded = "${pkgs.gamemode}/bin/gamemoded";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";

  # Function to simplify making waybar outputs
  jsonOutput =
    name:
    {
      pre ? "",
      text ? "",
      tooltip ? "",
      alt ? "",
      class ? "",
      percentage ? "",
    }:
    "${pkgs.writeShellScriptBin "waybar-${name}" ''
      set -euo pipefail
      ${pre}
      ${jq} -cn \
        --arg text "${text}" \
        --arg tooltip "${tooltip}" \
        --arg alt "${alt}" \
        --arg class "${class}" \
        --arg percentage "${percentage}" \
        '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
    ''}/bin/waybar-${name}";
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        mode = "dock";
        layer = "top";
        height = 40;
        position = "top";
        output = builtins.map (m: m.name) (builtins.filter (m: !m.noBar) config.monitors);
        modules-left = [
          "custom/oslogo"
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [
          "cpu"
          "custom/gpu"
          "memory"
          "clock"
          "pulseaudio"
        ];
        modules-right = [
          "custom/gamemode"
          "network"
          "battery"
          "tray"
          "idle_inhibitor"
          "custom/hostname"
        ];

        clock = {
          format = "{:%d/%m %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        cpu = {
          format = "   {usage}%";
        };
        "custom/gpu" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gpu" {
            text = "$(${cat} /sys/class/drm/card1/device/gpu_busy_percent)";
            tooltip = "GPU Usage";
          };
          format = "󰒋  {}%";
        };
        memory = {
          format = "󰍛  {}%";
          interval = 5;
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          spacing = 0;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          sort-by-app-id = true;
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [
              ""
              ""
              " "
            ];
          };
          on-click = pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        "wlr/workspaces" = {
          on-click = "activate";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "  {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };
        "custom/oslogo" = {
          return-type = "json";
          exec = jsonOutput "oslogo" {
            text = " ";
            tooltip = ''$(${cat} /etc/os-release | ${grep} PRETTY_NAME | ${cut} -d '"' -f2)'';
          };
        };
        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
        };
        "custom/gamemode" = {
          exec-if = "${gamemoded} --status | ${grep} 'is active' -q";
          interval = 2;
          return-type = "json";
          exec = jsonOutput "gamemode" {
            tooltip = "Gamemode is active";
          };
          format = " ";
        };
      };

    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style =
      with config.lib.stylix.colors.withHashtag;
      # css
      ''
        * {
          font-family: ${config.stylix.fonts.sansSerif.name}, ${config.stylix.fonts.monospace.name};
          font-size: 12pt;
          padding: 0 8px;
        }

        .modules-right {
          margin-right: -15px;
        }

        .modules-left {
          margin-left: -15px;
        }

        window#waybar.top {
          padding: 0;
          background-color: ${base00};
          border-radius: 20px;
        }

        window#waybar.bottom {
          background-color: ${base00};
          border-radius: 20px;
        }

        window#waybar {
          color: ${base05};
        }

        #workspaces button {
          border-radius: 20px;
          background-color: ${base01};
          color: ${base05};
          margin: 4px;
          padding: 2px;
        }
        #workspaces button.hidden {
          background-color: ${base00};
          color: ${base04};
        }
        #workspaces button.focused,
        #workspaces button.active {
          background-color: ${base0A};
          color: ${base00};
        }

        #clock {
          background-color: ${base0C};
          color: ${base00};
          padding-left: 25px;
          padding-right: 25px;
          margin: 4px;
          border-radius: 20px;
        }

        #taskbar button {
          border-radius: 20px;
          background-color: ${base01};
          color: ${base05};
          margin: 4px;
          padding: 2px;
        }

        #taskbar button.active {
          background-color: ${base0D};
          color: ${base00};
        }

        #custom-oslogo,
        #custom-hostname {
          background-color: ${base0C};
          color: ${base00};
          border-radius: 20px;
          margin: 4px;
          padding-left: 25px;
          padding-right: 20px;
        }

        #tray {
          color: ${base05};
        }
      '';
  };
}
