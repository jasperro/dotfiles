{ den, ... }:
{
  den.policies.settings-injection =
    {
      host ? null,
      home ? null,
      ...
    }:
    [
      (den.lib.policy.resolve {
        settings =
          if host ? settings then
            host.settings
          else if home ? settings then
            home.settings
          else
            throw "No settings found on host or home";
      })
    ];
}
