{ pkgs, ... }:
{
  # you'll need to add your user to 'libvirtd' group to use virt-manager
  environment.systemPackages = [ pkgs.virt-manager ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
    allowedBridges = [
      "virbr0"
      "virbr1"
    ];
  };
}
