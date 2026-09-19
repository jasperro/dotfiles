{
  jdf,
  ...
}:
{
  jdf.jasperro._.cli = {
    includes = [
      jdf.jasperro._.shell

      jdf.jasperro._.git
    ];
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          distrobox

          ripgrep
          httpie
          jq
          gnupg

          appimage-run
          gh

          nixd
          nixfmt
        ];
        programs.fzf = {
          enable = true;
        };
        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;
      };
  };
}
