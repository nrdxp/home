{
  imports = [mod.nebula];
  services.nebula.networks.nrd = {
    lighthouses = [
      "10.20.0.1"
      "10.20.0.2"
    ];
    settings = {
      preferred_ranges = [
        "fc00::/7"
        "127.0.0.0/8"
        "192.168.0.0/16"
        "10.0.0.0/8"
        "172.16.0.0/12"
      ];
      punchy = {
        punch = true;
        respond = true;
        target_all_remotes = false;
      };
    };
  };
}
