{
  config,
  pkgs,
  ...
}:
let
  mac = "02:00:00:00:02:02";
  keys = "/run/keys/castopod";
  version = "1.13.5";
in
{
  microvm = {
    hypervisor = "cloud-hypervisor";

    storeDiskErofsFlags = [
      "-zlz4hc"
      "-Eztailpacking"
    ];
    vcpu = 64;
    mem = 16384;
    interfaces = [
      {
        inherit mac;
        type = "tap";
        id = "vm-cp2";
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
        tag = "podman-state";
        source = "/var/lib/microvms/cp-app/containers";
        mountPoint = "/var/lib/containers";
      }
    ];
  };

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
        "192.168.100.3/24"
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

  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.openssh.settings.PasswordAuthentication = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+qICZVV3G5T9V4KsAaI2cvNjaSuNwZyPCv6enKxqmK tim@nrd.sh"
  ];

  services.cloudflared = {
    enable = true;
    certificateFile = "${keys}/cert.pem";
    tunnels = {
      "castopod" = {
        credentialsFile = "${keys}/creds.json";
        default = "http_status:404";
        ingress = {
          "thedeepdive.fm" = "http://localhost:8000";
        };
      };
    };
  };

  virtualisation.podman.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      app = {
        autoStart = false;
        image = "docker.io/castopod/app:${version}";

        hostname = "app";

        imageFile = pkgs.dockerTools.pullImage {
          imageName = "castopod/app";
          imageDigest = "sha256:066e52ef034bb9a12195dfaf94b5f3a34da512f96d893a476d69f81225262c01"; # From skopeo inspect
          sha256 = "sha256-Kk7QWIxN8xNXe/u84grx2LobsyPe2qTwJw0Xv+tho6w=";
          finalImageTag = version;
        };

        environmentFiles = [ "${keys}/env" ];
        environment = {
          CP_BASEURL = "https://thedeepdive.fm";
          CP_MEDIA_BASEURL = "https://pod.thedeepdive.fm";
          CP_DATABASE_HOSTNAME = "192.168.100.2";
          CP_DATABASE_NAME = "castopod";
          CP_DATABASE_USERNAME = "castopod";
          CP_CACHE_HANDLER = "redis";
          CP_REDIS_HOST = "192.168.100.2";
          CP_EMAIL_FROM = "support@thedeepdive.fm";
          CP_EMAIL_SMTP_USERNAME = "support@thedeepdive.fm";
          CP_EMAIL_SMTP_PORT = "587";
          CP_EMAIL_SMTP_CRYPTO = "tls";
          CP_MEDIA_FILE_MANAGER = "s3";
          CP_MEDIA_S3_BUCKET = "pod.thedeepdive.fm";
          CP_MEDIA_S3_KEY_PREFIX = "casts";
          CP_PHP_MEMORY_LIMIT = "12G";
          CP_ADMIN_GATEWAY = "admin";
          CP_AUTH_GATEWAY = "auth";
        };
      };
      web-server = {
        image = "docker.io/castopod/web-server:${version}";

        imageFile = pkgs.dockerTools.pullImage {
          imageName = "castopod/web-server";
          imageDigest = "sha256:292c36e24d174af25041b3ed95a758c3cee81650b4a40d62ae32fab735f4e173";
          sha256 = "sha256-94tW4TxrQikSoGg8/DicjHfrjbRx4cWDCouKFqg6+kU=";
          finalImageTag = version;
        };

        autoStart = false;
        environment = {
          CP_MAX_BODY_SIZE = "512M";
          CP_TIMEOUT = "900";
        };
        ports = [
          "8000:80"
        ];
        dependsOn = [ "app" ];
        extraOptions = [ ];
      };
    };
  };
}
