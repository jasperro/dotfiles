{
  jdf.hosts._.taart._.services._.home-automation._.matterjs-server.nixos =
    { ... }:
    {
      services.matterjs-server = {
        enable = true;
        openFirewall = true;
        listenAddress = "127.0.0.1";

        bluetoothSupport = true;
      };
    };
}
