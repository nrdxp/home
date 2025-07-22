{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.nebula.networks.nrd;
in
{
  services.nebula.networks.nrd = {
    enable = true;
    ca = "/run/keys/nebula/nebula_ca.crt";
    cert = "/run/keys/nebula/${config.networking.hostName}.${config.networking.domain}.crt";
    key = "/run/keys/nebula/${config.networking.hostName}.${config.networking.domain}.key";
    relays = cfg.lighthouses;
    firewall.inbound = [
      {
        description = "Allow pings";
        host = "any";
        port = "any";
        proto = "icmp";
      }
    ];
    firewall.outbound = [
      {
        host = "any";
        port = "any";
        proto = "any";
      }
    ];
    staticHostMap = {
      "10.20.0.1" = [ "143.110.146.56:4242" ];
      "10.20.0.2" = [ "161.35.112.247:4242" ];
    };
    settings.cipher = "aes";
    settings.pki.disconnect_invalid = true;
    settings.logging.level = "debug";
    settings.logging.disable_timestamp = true;
    settings.tun = {
      drop_local_broadcast = lib.mkDefault true;
      drop_multicast = lib.mkDefault true;
    };
    tun.device = "nebula.nrd";
  };
  systemd.services."nebula@nrd".serviceConfig.SupplementaryGroups = [ "keys" ];

  networking.firewall.interfaces.${cfg.tun.device} =
    let
      inherit (cfg.firewall) inbound;

      fmap =
        f:
        let
          g =
            acc: x:
            let
              y = f x;
            in
            if y == null then acc else [ y ] ++ acc;
        in
        builtins.foldl' g [ ];

      filterMap =
        f:
        let
          g =
            x:
            let
              y = f x;
            in
            if y == null then [ ] else [ y ];
        in
        builtins.concatMap g;

      select =
        proto:
        let
          f = x: if proto == x.proto then x.port else null;
        in
        fmap f;
    in
    {
      allowedTCPPorts = select "tcp" inbound;
      allowedUDPPorts = select "udp" inbound;
    };
  systemd.services.nebula-dns-config = lib.mkIf config.services.resolved.enable {
    enable = true;
    description = "Configure Nebula DNS for systemd-resolved";
    path = [ pkgs.systemd ];
    serviceConfig.Type = "simple";
    after = [ "nebula@nrd.service" ];
    bindsTo = [ "nebula@nrd.service" ];
    partOf = [ "nebula@nrd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Restart = "on-failure";
    serviceConfig.RestartSec = "1s";
    serviceConfig.RemainAfterExit = "yes";
    startLimitBurst = 20;
    startLimitIntervalSec = 1;
    script = ''
      resolvectl dnssec ${cfg.tun.device} no
      resolvectl dnsovertls ${cfg.tun.device} no
      resolvectl dns ${cfg.tun.device} ${toString cfg.lighthouses}
      resolvectl domain ${cfg.tun.device} '~${config.networking.domain}'
    '';
  };
}
