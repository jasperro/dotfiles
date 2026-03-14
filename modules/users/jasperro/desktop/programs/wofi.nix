{
  pkgs,
  config,
  ...
}:
{
  programs.wofi = {
    enable = true;
    package = pkgs.wofi.overrideAttrs (oa: {
      patches = (oa.patches or [ ]) ++ [
        ./wofi-run-shell.patch # Fix for https://todo.sr.ht/~scoopta/wofi/174
      ];
    });
    settings = {
      image_size = 48;
      columns = 3;
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
      run-exec_search = true;
    };
    style =
      let
        inherit (config.lib.stylix) colors;
      in
      with colors.withHashtag;
      ''
        window {
          border: 2px solid ${base0C};
          border-radius: 15px;
          font-family: ${config.stylix.fonts.sansSerif.name};
          font-size: 18px;
          background-color: rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 0.6);
          color: ${base05};
        }

        #input {
          border-radius: 15px 15px 0px 0px;
          border: 0;
          padding: 10px;
          margin: 0px;
          font-family: ${config.stylix.fonts.monospace.name};
          font-size: 28px;
          background-color: rgba(${colors.base01-rgb-r}, ${colors.base01-rgb-g}, ${colors.base01-rgb-b}, 0.3);
          color: ${base05};
          border-color: ${base02};
        }

        #input:focus {
          border-color: ${base0A};
        }

        #inner-box {
          margin: 5px;
        }

        #entry {
          border: 0;
          padding: 0px;
          margin: 2px;
          border-radius: 15px;
          background-color: background-color: rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 0.2);;
        }

        #entry:selected {
          background-color: ${base0D};
          color: ${base00};
          outline: none;
        }

        #entry:selected #text {
          color: ${base00};
        }

        #text {
          margin: 0px;
          padding: 2px 2px 2px 10px;
        }
      '';
  };
}
