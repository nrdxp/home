{lib, ...}: {
  services.fireqos.enable = true;
  services.fireqos.config = ''
    interface wan world-in input rate 105Mbit ethernet
      class nebula commit 40%
        match udp dport 4242
      class http commit 35%
        match sport 80
        match sport 443
      class interactive commit 10%
        match udp sport 53
        match tcp sport 853
        match tcp sport 22
      class default commit 15%
        match all

    interface wan world-out output rate 11Mbit ethernet
      class nebula commit 20%
        match udp dport 4242
      class http commit 10%
        match dport 80
        match dport 443
      class interactive commit 5%
        match udp dport 53
        match tcp dport 853
        match tcp dport 22
      class cache commit 50% ceil 85%
        match dst 138.68.34.161/32
      class default commit 15%
        match all
  '';
  systemd.services.fireqos.wantedBy = ["network-online.target"];
  systemd.services.fireqos.after = lib.mkForce ["sys-subsystem-net-devices-wan.device"];
  systemd.services.fireqos.bindsTo = ["sys-subsystem-net-devices-wan.device"];
}
