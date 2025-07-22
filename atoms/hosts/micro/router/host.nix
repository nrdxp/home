{ pkgs, config, ... }:
{
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
  ];
  boot.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # bind passthrough NIC early
  boot.blacklistedKernelModules = [
    "igb"
    "e1000e"
    "ixgbe"
  ];
  boot.extraModprobeConfig = ''
    options vfio-pci ids=8086:1563
  '';
  microvm.autostart = [ "router" ];
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks."10-net0" = {
      matchConfig.Name = "net0";
      networkConfig.DHCP = "yes";
      # stick with resolved config on this machine
      dhcpV4Config.UseDNS = "no";
      dhcpV6Config.UseDNS = "no";
      extraConfig = ''
        [IPv6AcceptRA]
        UseDNS = no
      '';
    };
  };
  microvm.vms.router = {
    config = {
      imports = [ mod.vm ];
      system = { inherit (config.system) stateVersion; };
    };
  };
}
