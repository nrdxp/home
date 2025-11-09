let
  inherit (deps.from) home;
  microvm-module = deps.pins.micro-vm.import "nixos-modules/host";
in {
  inherit (mod.config.system) build;
  eval = home.nix.nixpkgs.import "nixos/lib/eval-config.nix" {
    system = cfg.platform;
    inherit (mod) modules;
  };
  Config = mod.eval.config;
  System = mod.config.system.build.toplevel;
  Modules = [
    pre.nrd
    mod.host
    mod.jellyfin
    home.nix.os.module
    microvm-module
    home.network.ssh
    home.network.resolved
    home.network.nebula-client
    home.virt.libvirt
    home.virt.podman
    {
      containers.jelly.config.imports = [
        home.network.nebula-client
      ];
    }
    (
      {config, ...}: {
        services.nebula.networks.nrd.firewall = {
          inherit
            (config.containers.jelly.config.services.nebula.networks.nrd.firewall)
            inbound
            ;
        };
      }
    )
  ];
}
