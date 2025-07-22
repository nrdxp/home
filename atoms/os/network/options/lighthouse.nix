{
  lib,
  config,
  ...
}:
let
  cfg = config.do.lighthouse;
in
{
  options.do.lighthouse = {
    useDNS = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Run DNS resolution on this lighthouse
      '';
    };
    useAsRelay = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use this lighthouse as a relay
      '';
    };
    dnsBindAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        Address to bind the DNS listener to
      '';
    };
    network = lib.mkOption {
      type = lib.types.str;
      description = ''
        Name of the nebula network
      '';
    };
    interface = lib.mkOption {
      type = lib.types.str;
      default =
        let
          inherit (config.services.nebula.networks.${cfg.network}.tun) device;
        in
        if device != null then device else "nebula.${cfg.network}";
      description = ''
        Name of the nebula interface
      '';
    };
  };
  config = {
    services.nebula.networks.${cfg.network} = {
      isLighthouse = true;
      firewall.inbound = [
        {
          description = "SSH Access";
          groups = [
            "t:service:ssh"
          ];
          port = 22;
          proto = "tcp";
        }
      ]
      ++ (lib.optional cfg.useDNS {
        description = "DNS";
        host = "any";
        port = 53;
        proto = "udp";
      });
      settings.lighthouse.serve_dns = cfg.useDNS;
      settings.relay.am_relay = cfg.useAsRelay;
      settings.lighthouse.dns = {
        host = cfg.dnsBindAddress;
        port = 53;
      };
    };
    networking.firewall.interfaces.${cfg.interface}.allowedUDPPorts = lib.mkIf cfg.useDNS [ 53 ];
    systemd.services."nebula@${cfg.network}" = lib.mkIf cfg.useDNS {
      serviceConfig.AmbientCapabilities = lib.mkForce [
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_ADMIN"
      ];
      serviceConfig.CapabilityBoundingSet = lib.mkForce [
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_ADMIN"
      ];
    };
  };
}
