{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  jdf.users._.jasperro._.desktop._.niri._.noctalia = {
    nixos = {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };
    };
    homeManager = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      stylix.targets.noctalia.enable = true;

      wayland.windowManager.niri.settings.spawn-at-startup = [
        [
          "noctalia"
        ]
      ];

      programs.noctalia = {
        enable = true;
        settings = {
          bar.main = {
            background_opacity = 0.60;
            bar_type = "simple";
            concave_edge_corners = false;
            density = "default";
            display_mode = "always_visible";
            floating = false;
            frame_radius = 12;
            frame_thickness = 8;
            hide_on_overview = false;
            margin_horizontal = 8;
            margin_vertical = 6;
            monitors = [ ];
            outer_corners = true;
            position = "top";
            radius_top_left = 0;
            radius_top_right = 0;
            radius_bottom_left = 0;
            radius_bottom_right = 0;
            screen_overrides = [ ];
            show_capsule = false;
            show_outline = false;
            start = [
              "launcher"
              "wallpaper"
              "taskbar"
            ];
            use_separate_opacity = false;

            widgets = {
              center = [ "Workspace" ];
              left = [
                "Launcher"
                "Clock"
                "SystemMonitor"
                "ActiveWindow"
              ];
              right = [
                "MediaMini"
                "Tray"
                "NotificationHistory"
                "Volume"
                "Brightness"
                "NightLight"
                "KeepAwake"
                "ControlCenter"
              ];
            };
          };

          dock = {
            enabled = false;
          };

          lockscreen_widgets = {
            enabled = false;
            schema_version = 2;
            widget_order = [ "lockscreen-login-box@DP-2" ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget."lockscreen-login-box@DP-2" = {
              box_height = 70.0;
              box_width = 400.0;
              cx = 1280.0;
              cy = 1321.0;
              output = "DP-2";
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                input_opacity = 1.0;
                input_radius = 6.0;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_password_hint = true;
              };
            };
          };

          notification = {
            background_opacity = 0.60;
          };

          osd = {
            background_opacity = 0.60;
          };

          services = {
            audio = {
              volume_feedback = true;
            };
            brightness = {
              enable_ddc_support = true;
            };
            location = {
              name = "Hooglanderveen, Netherlands";
            };
            night_light = {
              enabled = true;
            };
          };

          shell = {
            clipboard_enabled = true;
            radius_ratio = 0.40;

            panel = {
              borders = false;
              floating_offset = 0;
              shadow = false;
              transparency_mode = "soft";
            };
          };

          wallpaper = {
            enabled = false;
          };

          widget = {
            ActiveWindow = {
              max_length = 550;
            };
            ControlCenter = {
              colorize_distro_logo = true;
              enable_colorization = true;
              use_distro_logo = true;
            };
            Workspace = {
              show_applications = true;
            };
            launcher = {
              capsule = true;
            };
            taskbar = {
              group_by_workspace = true;
              group_single_icon_per_app = true;
              inactive_opacity = 0.85;
            };
          };
        };
      };
    };
  };
}
