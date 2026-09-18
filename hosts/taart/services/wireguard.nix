{
  jdf,
  jdfPath,
  lib,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    nixos =
      {
        config,
        pkgs,
        host,
        ...
      }:
      let
        cfg = host.settings.services.wireguard;
        netCfg = host.settings.services.network;

        wgAddPeer = pkgs.writeShellScriptBin "wg-add-peer" ''
                  set -euo pipefail

                  NAME="''${1:-}"
                  IP="''${2:-}"

                  if [ -z "$NAME" ] || [ -z "$IP" ]; then
                    echo "Usage: sudo wg-add-peer <peer-name> <ip-address-with-prefix>"
                    echo "Example: sudo wg-add-peer phone 10.42.0.10/32"
                    exit 1
                  fi

                  DROPIN_DIR="/etc/systemd/network/10-wg0.netdev.d"
                  PEER_FILE="$DROPIN_DIR/50-peer-$NAME.conf"

                  # Generate client keys
                  PRIVKEY=$(${pkgs.wireguard-tools}/bin/wg genkey)
                  PUBKEY=$(echo "$PRIVKEY" | ${pkgs.wireguard-tools}/bin/wg pubkey)

                  # Retrieve server public key
                  SERVER_PRIVKEY_FILE="/var/lib/wireguard/private.key"
                  if [ ! -f "$SERVER_PRIVKEY_FILE" ]; then
                    echo "Error: /var/lib/wireguard/private.key not found."
                    exit 1
                  fi
                  SERVER_PUBKEY=$(${pkgs.wireguard-tools}/bin/wg pubkey < "$SERVER_PRIVKEY_FILE")

                  # Public endpoint
                  ENDPOINT="${cfg.host}:${toString cfg.port}"

                  # 1. Prepare client configuration string (Split Tunneling)
                  CLIENT_CONF=$(cat <<EOF
          [Interface]
          PrivateKey = $PRIVKEY
          Address = $IP
          DNS = 10.42.0.16

          [Peer]
          PublicKey = $SERVER_PUBKEY
          Endpoint = $ENDPOINT
          AllowedIPs = 10.42.0.0/23
          PersistentKeepalive = 25
          EOF
                  )

                  # 2. Persist peer config across reboots via systemd-networkd drop-in
                  cat <<EOF > "$PEER_FILE"
          [WireGuardPeer]
          PublicKey = $PUBKEY
          AllowedIPs = $IP
          PersistentKeepalive = 25
          EOF
                  chown systemd-network:systemd-network "$PEER_FILE"
                  chmod 600 "$PEER_FILE"

                  # 3. Apply peer directly to live interface instantly
                  echo "Applying peer to running wg0 interface..."
                  ${pkgs.wireguard-tools}/bin/wg set wg0 peer "$PUBKEY" allowed-ips "$IP" persistent-keepalive 25

                  # 4. Display QR code for mobile app
                  echo ""
                  echo "=== Scan this QR code with the WireGuard Mobile App ($NAME) ==="
                  echo "$CLIENT_CONF" | ${pkgs.qrencode}/bin/qrencode -t ansiutf8
                  echo "=============================================================="
                  echo "Peer saved to: $PEER_FILE"
        '';
      in
      {
        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        };

        # System packages for CLI and QR encoding
        environment.systemPackages = [
          pkgs.qrencode
          pkgs.wireguard-tools
          wgAddPeer
        ];

        systemd.tmpfiles.rules = [
          "d /etc/systemd/network/10-wg0.netdev.d  0700 systemd-network systemd-network - -"
          "d /var/lib/wireguard                    0700 systemd-network systemd-network - -"
          "Z /var/lib/wireguard/private.key        0600 systemd-network systemd-network - -"
          "Z /var/lib/wireguard/public.key         0600 systemd-network systemd-network - -"
        ];

        systemd.services.wireguard-keygen = {
          description = "Generate WireGuard Server Keys";
          wantedBy = [ "multi-user.target" ];
          before = [ "systemd-networkd.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "systemd-network";
            Group = "systemd-network";
            UMask = "0077"; # Ensures all created files automatically get 0600 permissions
          };
          script = ''
            if [ ! -f /var/lib/wireguard/private.key ]; then
              ${pkgs.wireguard-tools}/bin/wg genkey > /var/lib/wireguard/private.key
              ${pkgs.wireguard-tools}/bin/wg pubkey < /var/lib/wireguard/private.key > /var/lib/wireguard/public.key
            fi
          '';
        };

        networking.nftables.enable = true;

        networking.firewall = {
          enable = true;
          allowedUDPPorts = [
            cfg.port
          ];

          checkReversePath = "loose";
        };

        networking.nftables.tables = {
          wg-rules = {
            enable = true;
            family = "ip";
            content = ''
              chain wg_forward {
                type filter hook forward priority filter; policy accept;
                
                ct state established,related accept;
                iifname "wg0" oifname "wg0" ip saddr 10.42.0.0/24 ip daddr 10.42.0.0/24 accept;
                iifname "wg0" ip daddr 10.42.1.31 accept;
                iifname "wg0" ip daddr 10.42.1.16 accept;
                iifname "wg0" ip daddr 10.42.1.0/24 drop;
              }

              chain wg_postrouting {
                type nat hook postrouting priority srcnat; policy accept;
                ip saddr 10.42.0.0/24 oifname "${cfg.externalInterface}" masquerade;
              }
            '';
          };
        };

        systemd.network = {
          enable = true;

          netdevs."10-wg0" = {
            netdevConfig = {
              Kind = "wireguard";
              Name = "wg0";
            };
            wireguardConfig = {
              PrivateKeyFile = "/var/lib/wireguard/private.key";
              ListenPort = cfg.port;
            };
          };

          networks."10-wg0" = {
            matchConfig.Name = "wg0";
            address = [
              "10.42.0.16/24"
            ];
          };
        };
      };
  };
}
