{ pkgs, lib, ... }:
let
  mac = "02:00:00:00:02:01";
  keys = "/run/keys/castopod";
  ip = "192.168.100.2";
in

{
  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 32;
    mem = 32768;
    storeDiskErofsFlags = [
      "-zlz4hc"
      "-Eztailpacking"
    ];
    interfaces = [
      {
        inherit mac;
        type = "tap";
        id = "vm-cp1";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "keys";
        source = keys;
        mountPoint = keys;
      }
      {
        proto = "virtiofs";
        tag = "db";
        source = "/var/vm/castopod/db";
        mountPoint = "/var/lib/mysql";
      }
      {
        proto = "virtiofs";
        tag = "redis";
        source = "/var/vm/castopod/redis";
        mountPoint = "/var/lib/redis-castopod";
      }
    ];
  };

  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.settings.PasswordAuthentication = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+qICZVV3G5T9V4KsAaI2cvNjaSuNwZyPCv6enKxqmK tim@nrd.sh"
  ];

  systemd.network = {
    enable = true;
    links."10-virt" = {
      matchConfig.MACAddress = mac;
      linkConfig.Name = "virt0";
    };
    networks."10-virt0" = {
      matchConfig.Name = "virt0";
      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
      };
      # Static IP config
      address = [
        "${ip}/24"
      ];
      routes = [
        {
          routeConfig = {
            Gateway = "192.168.100.1";
            Destination = "0.0.0.0/0";
          };
        }
      ];
    };
  };
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "castopod" ];
  };

  services.redis.servers.castopod = {
    enable = true;
    port = 6379;
    settings.bind = lib.mkForce "127.0.0.1 ${ip}";
    requirePassFile = "${keys}/redis";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3306
      6379
    ];
  };

  systemd.services.mariadb-setup = {
    description = "Set up MariaDB user and permissions for Castopod";
    after = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mariadb-setup" ''
        #!/bin/sh
        PASS_FILE=${keys}/db-pass
        PASS=$(cat $PASS_FILE)
        ${pkgs.mariadb}/bin/mysql -u root -e "
          CREATE USER IF NOT EXISTS 'castopod'@'192.168.100.3' IDENTIFIED BY '$PASS';
          GRANT ALL PRIVILEGES ON castopod.* TO 'castopod'@'192.168.100.3';
          FLUSH PRIVILEGES;
        " && echo success
        # delete the password so it is not easily exposed
        umount /run/keys/castopod
      '';
    };
  };
}
