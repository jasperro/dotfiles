{
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  imports = [
    ../../lib/sharedNixConfig.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  programs.home-manager.enable = true;
  programs.lesspipe.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = lib.mkDefault "22.11";
}
