{config, ...}: {
  virtualisation = {
    podman.enable = true;
    podman.dockerCompat = !config.virtualisation.docker.enable;
    oci-containers.backend = "podman";
  };

  environment.shellAliases.pm = "podman";
}
