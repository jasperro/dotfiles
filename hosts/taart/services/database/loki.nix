let
  port = 3100;
in
{
  services.loki = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = port;
      };
      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
          };
        };
      };
      schema_config = {
        configs = [
          {
            from = "2025-09-13";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
      storage_config = {
        boltdb = {
          directory = "/var/lib/loki/index";
        };
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };
    };
    dataDir = "/var/lib/loki";
  };
}
