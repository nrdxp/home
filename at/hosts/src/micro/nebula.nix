{
  services.nebula.networks.nrd = {
    firewall.inbound = [
      {
        description = "SSH Access";
        groups = [
          "t:service:ssh"
        ];
        port = 22;
        proto = "tcp";
      }
    ];
    settings.routines = 32;
  };
}
