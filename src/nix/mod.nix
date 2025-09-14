{
  Pkgs = from.nixpkgs {};

  Module = mod.nix;

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
    imports = [from.hm-module];
  };
}
