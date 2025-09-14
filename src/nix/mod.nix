{
  Pkgs = from.nixpkgs {};

  Os.module = {
    imports = [
      mod.nix
      mod.hm.module
    ];

    nixpkgs.flake.source = mod.pkgs.path;
  };

  Hm.module = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    imports = [from.hm-module];
  };
}
