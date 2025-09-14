{
  pkgs,
  lib,
  ...
}: {
  nix = {
    gc.automatic = lib.mkDefault true;
    gc.dates = "weekly";
    optimise.automatic = true;

    nixPath = [
      "nixpkgs=${toString pkgs.path}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "flakes"
        "nix-command"
        "ca-derivations"
        "dynamic-derivations"
      ];
      accept-flake-config = true;
      flake-registry = get.registry.src;
      extra-substituters = [
        "https://cache.nrd.sh"
      ];
      extra-trusted-public-keys = [
        "cache.nrd.sh:KxAfP+PpOl/8UffuH1+lNr35DEsb/irKl7K7C2igbHQ="
      ];
    };
  };
}
