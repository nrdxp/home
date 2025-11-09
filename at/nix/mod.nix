let
  inherit (deps) pins;
  system = cfg.platform;
in {
  Pkgs = pins.nixpkgs.import "" {inherit system;};
  Nixpkgs = pins.nixpkgs;
  Hm.module = mod.nix;

  hm-module = pins.home-manager.import "nixos";
  Home-manager = pins.home-manager;

  Os.module = {
    imports = [
      mod.nix
      mod.hm.module
    ];

    nixpkgs.flake.source = toString mod.pkgs.path;
  };

  hm.module = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    imports = [mod.hm-module];
  };
}
