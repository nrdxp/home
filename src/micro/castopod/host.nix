{config, ...}: {
  microvm.host.enable = true;
  microvm.vms.cp-db = {
    config = {
      imports = [mod.db];
      system = {inherit (config.system) stateVersion;};
    };
  };

  microvm.vms.cp-app = {
    config = {
      imports = [mod.server];
      system = {inherit (config.system) stateVersion;};
    };
  };

  microvm.vms.router.config = let
    mac = "02:00:00:00:20:01";
  in {
    microvm.interfaces = [
      {
        inherit mac;
        type = "tap";
        id = "cast0";
      }
    ];

    systemd.network = {
      netdevs."10-br-cast0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-cast0";
        };
      };

      networks."10-br-cast0" = {
        matchConfig.Name = "br-cast0";
        networkConfig = {
          DHCPServer = true;
          IPv6SendRA = true;
          LinkLocalAddressing = "ipv6";
          DHCPPrefixDelegation = true;
        };
        ipv6SendRAConfig = {
          Managed = true;
          OtherInformation = true;
          RouterLifetimeSec = 1800;
        };
        dhcpPrefixDelegationConfig = {
          SubnetId = "1";
          UplinkInterface = "wan";
          Announce = true;
        };
        # dhcp server
        dhcpServerConfig.DNS = "_server_address";
        dhcpServerConfig.PoolOffset = 20;
        # subnet config
        addresses = [
          {
            addressConfig.Address = "192.168.100.1/24";
          }
        ];
        linkConfig.RequiredForOnline = "no";
      };

      links."10-virt-cast" = {
        matchConfig.MACAddress = mac;
        linkConfig.Name = "virt-cast";
      };

      networks."20-lan1" = {
        matchConfig.MACAddress = mac;
        networkConfig = {
          IPv6AcceptRA = false;
          DHCP = "no";
          Bridge = "br-cast0";
        };
        linkConfig.RequiredForOnline = "no";
      };
    };

    networking.nat = {
      enable = true;
      externalInterface = "wan";
      internalIPs = ["192.168.100.0/24"];
    };

    services.resolved.extraConfig = ''
      DNSStubListenerExtra=192.168.100.1
    '';

    # don't allow vm subnet to communicate with local LAN
    networking.firewall.extraForwardRules = ''
      ip saddr 192.168.1.0/24 oifname "br-cast0" drop
    '';
  };

  systemd.network = {
    netdevs."10-br-cast0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-cast0";
      };
    };

    networks."10-br-cast0" = {
      matchConfig.Name = "br-cast0";
      networkConfig = {
        DHCP = "yes";
        IPv6AcceptRA = true;
      };

      dhcpV6Config = {
        UseDNS = "no";
        WithoutRA = "solicit";
      };

      dhcpV4Config.UseDNS = "no";
      extraConfig = ''
        [IPv6AcceptRA]
        UseDNS = no
      '';
    };

    networks."20-cast0" = {
      matchConfig.Name = "cast0";
      networkConfig.Bridge = "br-cast0";
      linkConfig.RequiredForOnline = "no";
    };

    networks."30-cp" = {
      matchConfig.Name = "vm-cp*";
      networkConfig.Bridge = "br-cast0";
      linkConfig.RequiredForOnline = "no";
    };
  };
}
