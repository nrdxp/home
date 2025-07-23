let
  mac = "02:00:00:00:00:01";
in
{
  systemd.network = {
    links."10-virt" = {
      matchConfig.MACAddress = mac;
      linkConfig.Name = "virt";
    };

    networks."20-lan" = {
      matchConfig.MACAddress = mac;
      networkConfig = {
        IPv6AcceptRA = false;
        DHCP = "no";
        Bridge = "br0";
      };
      linkConfig.RequiredForOnline = "no";
    };
  };

  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 8;
    mem = 8192;
    interfaces = [
      {
        inherit mac;
        type = "tap";
        id = "net0";
      }
    ];

    # passthru the physical nics
    devices = [
      {
        bus = "pci";
        # wan
        path = "0000:01:00.1";
      }
      {
        bus = "pci";
        path = "0000:01:00.0";
      }
    ];
  };
}
