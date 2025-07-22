{
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    mod.router.host
    mod.nebula
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "ahci"
    "usbhid"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.fwupd.enable = true;
  security.sudo.wheelNeedsPassword = false;

  nix.gc.automatic = false;
  nix.settings.use-cgroups = true;
  nix.settings.auto-allocate-uids = true;
  nix.settings.experimental-features = [
    "cgroups"
    "auto-allocate-uids"
  ];
  nix.settings.max-jobs = 32;
  nix.settings.cores = 64;
  nix.nrBuildUsers = 0;
  nix.settings.secret-key-files = "/run/nix-key";

  fileSystems."/" = {
    device = "UUID=3ffceb6b-1eab-4e44-8c80-ceb1233dd4f8";
    fsType = "bcachefs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/53D3-8A01";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "micro";
  networking.domain = "nrd";
  networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  networking.interfaces.eno2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  time.timeZone = "America/Denver";

  services.fstrim.enable = true;

  systemd.services.taskspooler =
    let
      socket = "/var/run/socket-ts";
    in
    {
      environment.TS_SOCKET = socket;
      serviceConfig.ExecStart = "${pkgs.taskspooler}/bin/ts -S8";
      serviceConfig.Type = "forking";
      serviceConfig.ExecStartPost = "${pkgs.coreutils}/bin/chmod 777 ${socket}";
      wantedBy = [ "multi-user.target" ];
    };

  system.stateVersion = "24.05";
}
