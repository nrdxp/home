{lib, ...}: {
  networking.networkmanager = {
    enable = true;
    dns = lib.mkForce "systemd-resolved";
    settings = {
      main.systemd-resolved = true;
      connection."ethernet.cloned-mac-address" = "random";
      connection."ipv6.ip6-privacy" = 2;
    };
    wifi.backend = "iwd";
  };
}
