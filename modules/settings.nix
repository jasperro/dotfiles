{
  den,
  jdf,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  settingsType =
    let
      # Keys that are NOT child aspects: structural keys (includes, nixos, …),
      # plus your framework's registered class names and quirk/extension keys.
      # Adapt these three sources to your own framework.
      inherit (den.lib.aspects.fx.keyClassification) structuralKeysSet;
      classKeys = den.classes or { };
      quirkKeys = den.quirks or { };
      skipKey = k: structuralKeysSet ? ${k} || classKeys ? ${k} || quirkKeys ? ${k};

      # A settings block may be a plain options attrset ({ foo = mkOption {...}; })
      # OR module-shaped ({ imports; config; options; }). Normalize to the latter.
      reshapeSettings =
        raw:
        let
          # Bind to DISTINCT names on purpose — see the statix gotcha below.
          imports' = raw.imports or [ ];
          config' = raw.config or { };
        in
        {
          imports = imports';
          config = config';
          options = removeAttrs raw [
            "imports"
            "config"
          ];
        };

      # True if this node, or anything beneath it, declares settings.
      hasSettingsDeep =
        node:
        builtins.isAttrs node
        && (
          (node ? settings)
          || lib.any (k: !(skipKey k) && hasSettingsDeep (node.${k} or null)) (builtins.attrNames node)
        );

      # Build the submodule for one aspect-tree node, mirroring the tree.
      # Merge the node's OWN settings options with recursion into its
      # settings-bearing children.
      nodeModule =
        node:
        let
          ownSettings =
            if node ? settings then
              reshapeSettings node.settings
            else
              {
                imports = [ ];
                config = { };
                options = { };
              };

          settingChildren = lib.filterAttrs (
            k: v: !(skipKey k) && builtins.isAttrs v && hasSettingsDeep v
          ) node;

          childOptions = lib.mapAttrs (
            name: child:
            mkOption {
              type = types.submodule (nodeModule child);
              default = { };
              description = "Settings under ${name}";
            }
          ) settingChildren;

          # Distinct names again — keep statix from dropping the `or` default.
          ownImports = ownSettings.imports or [ ];
          ownConfig = ownSettings.config or { };
        in
        {
          imports = ownImports;
          config = ownConfig;
          options = (ownSettings.options or { }) // childOptions;
        };
    in
    types.submodule (nodeModule (jdf.hosts._.taart._.service-configs or { }));
in
{
  den.reservedKeys = [ "settings" ];

  # Applies to hosts, homes, and users, but I tend to configure everything in the host/home side.
  den.schema.conf = {
    imports = [
      {
        options.settings =
          mkOption {
            type = settingsType;
            default = { };
            description = "Per-aspect typed settings";
          }
          # Exclude settings from entity identity hashing
          // {
            identity = false;
          };
      }
    ];
  };
}
