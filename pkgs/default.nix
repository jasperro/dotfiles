# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ nixpak, pkgs ? (import ../nixpkgs.nix) { } }:
# example = pkgs.callPackage ./example { };
let
  mkNixPak = nixpak.lib.nixpak rec {
    inherit pkgs;
    inherit (pkgs) lib;
  };
  _sandboxed-firefox-wayland = mkNixPak {
    config = { sloth, ... }: {

      # the application to isolate
      app.package = pkgs.firefox-wayland;

      dbus.enable = true;

      # same usage as --see, --talk, --own
      dbus.policies = {
        "org.freedesktop.DBus" = "talk";
        "ca.desrt.dconf" = "talk";
      };

      bubblewrap = {

        # disable all network access
        network = true;

        # lists of paths to be mounted inside the sandbox
        # supports runtime resolution of environment variables
        # see "Sloth values" below
        bind.rw = [
          (sloth.env "XDG_RUNTIME_DIR")
          (sloth.concat' sloth.homeDir "/.mozilla")
        ];
        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")
        ];
        bind.dev = [
          "/dev/dri"
        ];
      };
    };
  };
in
{
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
  sandboxed-firefox-wayland = _sandboxed-firefox-wayland.config.env;

}
