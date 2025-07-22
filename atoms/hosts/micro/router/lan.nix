let
  subnet = "192.168.1";
  subnet6 = "fd12:3456:789a";
  routerIP = "${subnet}.1";
  routerIP6 = "${subnet6}::1";
  cidr = "${subnet}.0/24";
  cidr6 = "${subnet6}::/64";
in
{
  systemd.network = {
    netdevs."10-br0".netdevConfig = {
      Kind = "bridge";
      Name = "br0";
    };

    networks."10-br0" = {
      matchConfig.Name = "br0";
      # Hand out IP addresses to local clients.
      # Use `networkctl status br0` to see leases.
      networkConfig = {
        DHCPServer = true;
        IPv6SendRA = true;
        LinkLocalAddressing = "ipv6";
      };
      # dhcp server
      dhcpServerConfig.DNS = "_server_address";
      dhcpServerConfig.PoolOffset = 20;
      dhcpServerStaticLeases = [
        # AP
        {
          dhcpServerStaticLeaseConfig = {
            MACAddress = "fc:34:97:6d:38:20";
            Address = "192.168.1.2";
          };
        }
        {
          # host
          dhcpServerStaticLeaseConfig = {
            MACAddress = "92:6a:39:c4:5e:37";
            Address = "192.168.1.3";
          };
        }
        # laptop
        {
          dhcpServerStaticLeaseConfig = {
            MACAddress = "f8:ac:65:fd:f5:34";
            Address = "192.168.1.4";
          };
        }
        # ipmi
        {
          dhcpServerStaticLeaseConfig = {
            MACAddress = "3c:ec:ef:71:a7:ef";
            Address = "192.168.1.5";
          };
        }
      ];
      # subnet config
      addresses = [
        {
          addressConfig.Address = "${routerIP}/24";
        }
        {
          addressConfig.Address = "${routerIP6}/64";
        }
      ];
      ipv6Prefixes = [
        {
          ipv6PrefixConfig.Prefix = cidr6;
        }
      ];
      linkConfig.RequiredForOnline = "no";
    };

    networks."20-br0" = {
      matchConfig.Name = "ens*";
      networkConfig.Bridge = "br0";
      linkConfig.RequiredForOnline = "no";
    };
  };

  networking.nftables.enable = true;
  networking.firewall.allowPing = false;
  # allow dhcp, ssh and dns from lan
  networking.firewall.interfaces.br0.allowedUDPPortRanges = [
    {
      from = 67;
      to = 68;
    }
  ];
  networking.firewall.interfaces.br0.allowedUDPPorts = [ 53 ];
  networking.firewall.interfaces.br0.allowedTCPPorts = [
    22
    53
  ];

  # NAT config
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "wan";
    internalIPs = [ cidr ];
    internalIPv6s = [ cidr6 ];
  };

  # dns config
  networking.nameservers = [
    "1.1.1.3#family.cloudflare-dns.com"
    "2606:4700:4700::1113#family.cloudflare-dns.com"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    fallbackDns = [
      "1.0.0.3#family.cloudflare-dns.com"
      "2606:4700:4700::1003#family.cloudflare-dns.com"
    ];
    extraConfig = ''
      DNSStubListenerExtra=${routerIP}
    '';
  };
}
