{
  imports = [
    mod.virt
    mod.wan
    mod.lan
    # mod.qos
  ];
  nix.enable = false;

  networking.hostName = "router";
  networking.domain = "internal";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  systemd.network.enable = true;

  services.openssh.enable = true;
  services.openssh.openFirewall = false;
  services.openssh.settings.PasswordAuthentication = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+qICZVV3G5T9V4KsAaI2cvNjaSuNwZyPCv6enKxqmK tim@nrd.sh"
  ];
}
