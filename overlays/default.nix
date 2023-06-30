# This file defines overlays
{ nixpak }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; inherit nixpak; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    extraNodePackages = {
      "cssmodules-language-server" = prev.buildNpmPackage rec {
        pname = "cssmodules-language-server";
        version = "1.2.1";
        src = prev.fetchFromGitHub {
          owner = "antonk52";
          repo = pname;
          rev = "cd5eb579027d880b74dd0fc456c6a235e0385017";
          hash = "sha256-S1iZUajykYXUp8jFskWe/dJr733vV1vevO1vuKxxkeA=";
        };
        npmDepsHash = "sha256-SPjLie7/2ej5lVKrXBZaVBq6EXDglcJ9JC1HaN4wz2c=";
        npmPackFlags = [ "--ignore-scripts" ];
        npmFlags = [ "--legacy-peer-deps" ];
        makeCacheWritable = true;
      };
    };
  };
}
