inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } {
  debug = true;
  imports = [
    (inputs.import-tree [
      ./modules
      ./hosts
      ./homes
    ])
  ];
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
