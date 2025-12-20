{
  description = "Jasperro's Dotfiles Flake";

  inputs = {
    self.submodules = true;

    secrets = {
      url = "./secrets";
      flake = false;
      buildTime = true;
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    flake-compat.url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Misterio77/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    impurity.url = "github:outfoxxed/impurity.nix";

    waybar = {
      url = "github:jasperro/Waybar/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
    };

    wofi-power-menu = {
      url = "github:szaffarano/wofi-power-menu";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nix/devShells.nix
        ./nix/formatter.nix
        ./nix/hosts.nix
        ./nix/lib.nix
        ./nix/modules.nix
        ./nix/overlays.nix
        ./nix/packages.nix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
