{
  jdf,
  lib,
  ...
}:
{
  jdf.hosts._.taart._.services._.wireguard.nixos =
    {
      config,
      pkgs,
      host,
      ...
    }:
    let
      cfg = host.settings.services.wireguard;
      netCfg = host.settings.services.network;

      mkWgPeer =
        {
          publicKey,
          allowedIPs,
          endpoint ? null,
          keepAlive ? 25,
        }:
        {
          WireGuardPeer = {
            PublicKey = publicKey;
            AllowedIPs = allowedIPs;
            PersistentKeepalive = keepAlive;
          }
          // (lib.optionalAttrs (endpoint != null) { Endpoint = endpoint; });
        };

      translateToVpnIp =
        ip:
        let
          cleanIp = lib.head (lib.splitString "/" ip);
          hostOctet = lib.last (lib.splitString "." cleanIp);
        in
        "10.42.0.${hostOctet}";

      dnsMasqRecords = lib.concatLists (
        lib.mapAttrsToList (
          lanIp: subdomains:
          let
            vpnIp = translateToVpnIp lanIp;
          in
          map (subdomain: "/${subdomain}.${netCfg.baseDomain}/${vpnIp}") subdomains
        ) netCfg.lanDevices
      );

      # Script to add WireGuard peers live and persist them to netdev.d
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
                SERVER_PUBKEY_FILE="/var/lib/wireguard/public.key"
                if [ ! -f "$SERVER_PUBKEY_FILE" ]; then
                  if [ -f "/var/lib/wireguard/private.key" ]; then
                    ${pkgs.wireguard-tools}/bin/wg pubkey < /var/lib/wireguard/private.key > "$SERVER_PUBKEY_FILE"
                  else
                    echo "Error: /var/lib/wireguard/private.key not found."
                    exit 1
                  fi
                fi
                SERVER_PUBKEY=$(cat "$SERVER_PUBKEY_FILE")

                # Public endpoint
                ENDPOINT="${netCfg.baseDomain}:${toString cfg.port}"

                # 1. Prepare client configuration string
                CLIENT_CONF=$(cat <<EOF
        [Interface]
        PrivateKey = $PRIVKEY
        Address = $IP
        DNS = 10.42.0.1

        [Peer]
        PublicKey = $SERVER_PUBKEY
        Endpoint = $ENDPOINT
        AllowedIPs = 0.0.0.0/0, ::/0
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

      # Ensure drop-in directories exist with proper permissions
      systemd.tmpfiles.rules = [
        "d /etc/systemd/network/10-wg0.netdev.d 0700 root root - -"
        "d /var/lib/wireguard 0700 root root - -"
      ];

      networking.firewall = {
        enable = true;
        allowedUDPPorts = [
          cfg.port
          53
        ];

        allowedTCPPorts = [ 53 ];

        extraCommands = ''
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i wg0 -d 10.42.0.0/24 -j NETMAP --to 192.168.1.0/24
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.42.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        extraStopCommands = ''
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i wg0 -d 10.42.0.0/24 -j NETMAP --to 192.168.1.0/24
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.42.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
        '';
      };

      services.dnsmasq = {
        enable = true;
        settings = {
          interface = "wg0";
          bind-dynamic = true;
          listen-address = "10.42.0.1";
          server = [
            "1.1.1.1"
            "1.0.0.1"
          ];
          address = dnsMasqRecords;
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
          address = [ "10.42.0.1/24" ];
          networkConfig = {
            IPForward = "yes";
          };
        };
      };
    };
}
