let
  port = 3100;
in
{
  services.loki = rec {
    enable = true;
    configuration = {
      auth_enabled = false;
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
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
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
        tsdb_shipper = {
          active_index_directory = "${dataDir}/tsdb-index";
          cache_location = "${dataDir}/tsdb-cache";
        };
        filesystem = {
          directory = "${dataDir}/chunks";
        };
      };
      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = dataDir;
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
    dataDir = "/var/lib/loki";
  };
}
