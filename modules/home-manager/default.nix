# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # List your module files here
  fonts = import ./fonts.nix;
  wallpaper = import ./wallpaper.nix;
  monitors = import ./monitors.nix;
  astronvim = import ./astronvim.nix;
  gtklock = import ./gtklock.nix;
}
