{config, ...}: {
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "eno2";
    internalInterfaces = ["ve-jelly" "nebula.nrd"];
  };

  users.users.nebula-nrd.uid = 993;

  containers.jelly = {
    enableTun = true;
    autoStart = true;
    bindMounts."/srv/jellyfin" = {
      isReadOnly = false;
      hostPath = "/srv/jellyfin";
    };
    bindMounts."/var/keys/nebula" = {
      hostPath = "/run/keys/nebula";
    };
    ephemeral = true;
    privateNetwork = false;
    config = {
      pkgs,
      lib,
      ...
    }: {
      services.jellyfin.enable = true;
      services.jellyfin.dataDir = "/srv/jellyfin";
      services.jellyfin.user = "root";
      services.jellyfin.group = "root";
      services.resolved.enable = true;

      systemd.tmpfiles.rules = [
        "L+ /run/keys/nebula - - - - /var/keys/nebula"
      ];

      users.users.nebula-nrd.uid = config.users.users.nebula-nrd.uid;

      systemd.services.jellyfin.serviceConfig.PrivateUsers = lib.mkForce false;
      networking.firewall.enable = true;
      networking.firewall.allowedUDPPorts = [1900 7359];

      services.nebula.networks.nrd = {
        firewall.inbound = [
          {
            description = "Jellyfin Access";
            groups = [
              "t:service:jellyfin"
            ];
            port = 80;
            proto = "tcp";
          }
          {
            description = "Jellyfin DLNA Access";
            groups = [
              "t:service:jellyfin"
            ];
            port = 1900;
            proto = "udp";
          }
          {
            description = "Jellyfin DLNA Access";
            groups = [
              "t:service:jellyfin"
            ];
            port = 7359;
            proto = "udp";
          }
        ];
      };
      services.nebula.networks.nrd.settings.tun.drop_multicast = false;

      networking.useHostResolvConf = lib.mkForce false;
      networking.domain = "nrd";
    };
  };
}
