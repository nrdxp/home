{
  inherit (mod.config.system) build;
  eval = from.eval-config {
    inherit (mod) modules;
  };
  Config = mod.eval.config;
  System = mod.config.system.build.toplevel;
  Modules = [
    pre.nrd
    mod.host
    from.nix.os.module
    from.microvm-module
    from.network.ssh
    from.network.resolved
    from.network.nebula-client
    from.virt.libvirt
    from.virt.podman
  ];
}
