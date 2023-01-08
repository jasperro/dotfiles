{ pkgs, ... }:
{
  imports = [ ../../../modules/home-manager/astronvim.nix ];
  astronvim = {
    enable = true;
    userConfig = ./astro-userconfig;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs; [ ];
  };

  home.packages = with pkgs; [
    ripgrep
    gnumake

    # General
    rnix-lsp
    nodePackages.yaml-language-server
    nodePackages.vim-language-server

    gopls
    haskell-language-server
    kotlin-language-server
    omnisharp-roslyn
    python310Packages.python-lsp-server
    rust-analyzer

    texlab

    # Webdev
    nodePackages.vscode-langservers-extracted # html, json, css...
    nodePackages.typescript-language-server
    nodePackages.vue-language-server
    nodePackages.svelte-language-server
    nodePackages.stylelint
    # nodePackages.rome
    nodePackages."@astrojs/language-server"
    nodePackages."@tailwindcss/language-server"
    # nodePackages.cssmodules-language-server
    # nodePackages.emmet-ls
  ];
}
