{
  Ssh = {
    programs.ssh.enableAskPassword = false;
    services.openssh.enable = true;
    services.openssh.openFirewall = true;
    services.openssh.settings.PasswordAuthentication = false;
  };

  Qbittorrent = {
    imports = [
      mod.options.qbittorrent
      (
        { config, ... }:
        {
          systemd.tmpfiles.rules = [
            "L+ /home/nrd/torrents - - - - ${config.services.qbittorrent.dataDir}/.config/qBittorrent/downloads"
          ];
        }
      )
    ];

    services.qbittorrent = {
      enable = true;
      group = "media";
      openFirewall = true;
      dataDir = "/srv/qbittorrent";
      port = 57347;
      autostart = false;
    };
  };

  Networkmanager = mod.networkmanager;

  Resolved = mod.resolved;

  Nebula = mod.nebula;
  Nebula-client = mod.nebula-client;

  Wireguard =
    { lib, ... }:
    {
      networking.wireguard.enable = true;
      networking.firewall.checkReversePath = lib.mkForce false;
    };
}
