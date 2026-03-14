{ __findFile, ... }:
{
  JDF.users._.jasperro._.cli = {
    includes = [
      <JDF/cli/jasperro-shell>

      <JDF/users/jasperro/git>
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
