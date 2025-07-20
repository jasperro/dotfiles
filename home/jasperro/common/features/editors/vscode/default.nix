{ impurity, lib, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = lib.mkForce {};
  };
  stylix.targets.vscode = {
    enable = true;
  };

  # xdg.configFile = {
  #   "Code/User/settings.json".source = impurity.link ./userSettings.json;
  # };

  # Plugin list
  # arcticicestudio.nord-visual-studio-code
  # arrterian.nix-env-selector
  # astro-build.astro-vscode
  # bradlc.vscode-tailwindcss
  # catppuccin.catppuccin-vsc
  # csstools.postcss
  # dbaeumer.vscode-eslint
  # docker.docker
  # dracula-theme.theme-dracula
  # eamodio.gitlens
  # editorconfig.editorconfig
  # esbenp.prettier-vscode
  # geequlim.godot-tools
  # github.copilot
  # github.copilot-chat
  # github.github-vscode-theme
  # golang.go
  # graphql.vscode-graphql
  # graphql.vscode-graphql-syntax
  # haskell.haskell
  # jbockle.jbockle-format-files
  # jdinhlife.gruvbox
  # jnoortheen.nix-ide
  # justusadam.language-haskell
  # karunamurti.haml
  # mkhl.direnv
  # monosans.djlint
  # ms-azuretools.vscode-containers
  # ms-dotnettools.csdevkit
  # ms-dotnettools.csharp
  # ms-dotnettools.vscode-dotnet-runtime
  # ms-dotnettools.vscodeintellicode-csharp
  # ms-python.debugpy
  # ms-python.isort
  # ms-python.python
  # ms-python.vscode-pylance
  # ms-toolsai.jupyter
  # ms-toolsai.jupyter-keymap
  # ms-toolsai.jupyter-renderers
  # ms-toolsai.vscode-jupyter-cell-tags
  # ms-toolsai.vscode-jupyter-slideshow
  # ms-vscode-remote.remote-containers
  # ms-vscode-remote.remote-ssh
  # ms-vscode-remote.remote-ssh-edit
  # ms-vscode-remote.remote-wsl
  # ms-vscode-remote.vscode-remote-extensionpack
  # ms-vscode.cmake-tools
  # ms-vscode.cpptools
  # ms-vscode.cpptools-extension-pack
  # ms-vscode.cpptools-themes
  # ms-vscode.makefile-tools
  # ms-vscode.remote-explorer
  # ms-vscode.remote-server
  # mtxr.sqltools
  # mushan.vscode-paste-image
  # pinage404.nix-extension-pack
  # platformio.platformio-ide
  # rokoroku.vscode-theme-darcula
  # rust-lang.rust-analyzer
  # s0kil.vscode-hsx
  # shd101wyy.markdown-preview-enhanced
  # sjurmillidahl.ormolu-vscode
  # stylelint.vscode-stylelint
  # stylix.stylix
  # svelte.svelte-vscode
  # tamasfe.even-better-toml
  # thenuprojectcontributors.vscode-nushell-lang
  # twxs.cmake
  # unifiedjs.vscode-mdx
  # vitest.explorer
  # vscodevim.vim
  # vue.volar
  # wix.glean
  # yzhang.markdown-all-in-one
  # zhuangtongfa.material-theme
}
