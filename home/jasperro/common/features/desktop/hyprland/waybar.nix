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
          # "wlr/taskbar"
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
          format = "󰍛   {usage}%";
        };
        "custom/gpu" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gpu" {
            text = "$(${cat} /sys/class/drm/card1/device/gpu_busy_percent)";
            tooltip = "GPU Usage";
          };
          format = "󰾲   {}%";
        };
        memory = {
          format = "   {}%";
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
          format = "{icon} {volume}%";
          format-muted = "󰸈 0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          max-volume = 150;
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
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}:{windows}";
          format-window-separator = "";
          workspace-taskbar = {
            enable = true;
            update-active-window = true;
            # format = "{icon}{title:.16}";
            format = "{icon}";
            icon-size = 14;
          };
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀  Connected";
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
            text = "";
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
          format = "󰺵 ";
        };
      };

    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style =
      let
        borderRadius = "10px";
      in
      (
        with config.lib.stylix.colors.withHashtag;
        # css
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

          @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
        '')
      + (with config.lib.stylix.colors; ''
        * {
          all: unset;
          font-family: ${config.stylix.fonts.sansSerif.name}, ${config.stylix.fonts.monospace.name};
          font-size: 12pt;
          font-weight: bold;
          padding: 0 8px;
        }

        window#waybar.top,
        window#waybar.bottom {
          padding: 0;
          background-color: rgba(${base00-rgb-r}, ${base00-rgb-g}, ${base00-rgb-b}, 0.8);
        }

        window#waybar {
          color: @base05;
        }

        .modules-right {
          margin-right: -15px;
        }

        .modules-left {
          margin-left: -15px;
        }

        tooltip {
          background-color: rgba(${base00-rgb-r}, ${base00-rgb-g}, ${base00-rgb-b}, 0.6);
          border-radius: 4px;
          border: 2px solid @base05;
        }

        tooltip label {
          color: @base05;
        }

        #workspaces button {
          border: 2px solid @base03;
          border-radius: ${borderRadius};
          background-color: rgba(${base00-rgb-r}, ${base00-rgb-g}, ${base00-rgb-b}, 0.4);
          color: @base05;
          margin: 4px;
          padding: 2px;
        }

        #workspaces button.hidden {
          background-color: @base00;
          color: @base04;
        }

        #workspaces button.focused,
        #workspaces button.active {
          border-color: @base0D;
        }

        #workspaces .taskbar-window {
          padding: 0 0 2px 0;
          margin: 0;
          border-top: 2px solid transparent;
        }

        #workspaces .taskbar-window.active {
          border-color: @base05;
        }

        #taskbar button {
          border-radius: ${borderRadius};
          background-color: @base01;
          color: @base05;
          margin: 4px;
          padding: 2px;
        }

        #taskbar button.active {
          background-color: @base0D;
          color: @base00;
        }

        #custom-oslogo,
        #custom-hostname,
        #clock {
          border-radius: ${borderRadius};
          border: 2px solid @base0C;
          background-color: rgba(${base00-rgb-r}, ${base00-rgb-g}, ${base00-rgb-b}, 0.4);
          color: @base05;
          margin: 4px;
          padding: 2px 16px;
        }

        #custom-oslogo {
          padding-right: 22px;
        }

        #tray {
          color: @base05;
        }
      '');
  };
}
