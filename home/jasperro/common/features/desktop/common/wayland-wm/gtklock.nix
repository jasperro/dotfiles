{ ... }:
{
  programs.gtklock = {
    enable = true;
    settings = {
      main = {
        gtk-theme = "Adwaita-dark";
      };
    };
  };
}
