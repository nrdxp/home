{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  environment.shellAliases.dk = "docker";
}
