inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } {
  debug = true;
  imports =
    let
      lib = inputs.nixpkgs.lib;

      mapTree =
        baseDir: prefixSegments:
        (inputs.import-tree.addPath baseDir).map (
          file:
          let
            relPath = lib.removePrefix (toString baseDir + "/") (toString file);
            cleanPath = lib.removeSuffix ".nix" relPath;
            rawSegments' = lib.splitString "/" cleanPath;

            rawSegments = if lib.last rawSegments' == "default" then lib.init rawSegments' else rawSegments';

            interleaved = lib.intersperse "_" rawSegments;

            fullPath =
              if rawSegments == [ ] then
                prefixSegments
              else if prefixSegments == [ ] then
                interleaved
              else
                prefixSegments ++ [ "_" ] ++ interleaved;

            imported = import file;
          in
          if builtins.isFunction imported then
            lib.setFunctionArgs (args: imported (args // { jdfPath = fullPath; })) (
              builtins.functionArgs imported
            )
          else
            imported
        );
    in
    [
      (mapTree ./modules [ ])
      (mapTree ./homes [ "homes" ])
      (mapTree ./hosts [ "hosts" ])
    ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
