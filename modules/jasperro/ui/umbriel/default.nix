{
  inputs,
  jdf,
  jdfPath,
  lib,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    includes = [
      jdf.ui._.stylix

      jdf.ui._.umbriel
      jdf.jasperro._.ui._.umbriel._.blur
      jdf.jasperro._.ui._.umbriel._.outputs
      jdf.jasperro._.ui._.umbriel._.workspaces
      jdf.jasperro._.ui._.umbriel._.keybinds

      jdf.jasperro._.ui._.wayland-wm

      jdf.jasperro._.ui._.programs._.cliphist
      jdf.jasperro._.ui._.programs._.kitty
    ];

    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.umbriel.homeModules.default
        ];

        home.packages =
          with pkgs;
          [
            grimblast
            hyprsunset
            inputs.noctalia.packages.${stdenv.hostPlatform.system}.default
            waypaper
            swaybg
          ]
          ++ lib.optionals config.programs.wofi.enable [
            inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];

        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
          ];
          config = {
            umbriel = {
              "org.freedesktop.impl.portal.FileChooser" = "kde";
            };
          };
        };

        programs.umbriel = {
          enable = true;
          settings = {
            general = {
              autostart = [
                "waypaper --restore --random"
              ];
            };

            layout = {
              gap = 10;
              extent_presets = [
                (1. / 3.)
                (1. / 2.)
                (2. / 3.)
              ];
            };

            input = {
              keyboard = {
                layout = "us";
                variant = "altgr-intl";
                options = "terminate:ctrl_alt_bksp";
              };
            };
          };
        };

        services.hypridle =
          let
            noctalia = "${lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default} msg";
          in
          {
            enable = config.programs.hyprlock.enable || config.programs.noctalia.enable;
            settings = {
              general =
                if config.programs.hyprlock.enable then
                  {
                    before_sleep_cmd = "hyprlock --immediate";
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                    ignore_dbus_inhibit = false;
                    lock_cmd = "hyprlock --immediate";
                  }
                else
                  {
                    before_sleep_cmd = "${noctalia} session lock";
                    after_sleep_cmd = "umbriel msg dpms on";
                    ignore_dbus_inhibit = false;
                    lock_cmd = "${noctalia} session lock";
                  };

              listener =
                if config.programs.hyprlock.enable then
                  [
                    {
                      timeout = 900;
                      on-timeout = "hyprlock";
                    }
                    {
                      timeout = 1200;
                      on-timeout = "hyprctl dispatch dpms off";
                      on-resume = "hyprctl dispatch dpms on";
                    }
                  ]
                else
                  [
                    {
                      timeout = 900;
                      on-timeout = "${noctalia} session lock";
                    }
                    {
                      timeout = 1200;
                      on-timeout = "umbriel msg dpms off";
                      on-resume = "umbriel msg dpms on";
                    }
                  ];
            };
          };

        programs.hyprlock = {
          enable = false;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 15;
              hide_cursor = true;
              no_fade_in = false;
            };

            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = with config.lib.stylix.colors; [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(${base0F})";
                inner_color = "rgb(${base00})";
                outer_color = "rgb(${base0C})";
                outline_thickness = 5;
                placeholder_text = "Password...";
                shadow_passes = 2;
              }
            ];
          };
        };
      };
  };
}
