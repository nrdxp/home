{
  Main = get.hm-config {
    inherit (mod) configuration;
    inherit (get.nix) pkgs;
  };
  Shell = get.nix.pkgs.mkShell {
    packages = with mod.pkgs; [
      treefmt
      alejandra
      shfmt
      taplo
      nodePackages.prettier
    ];
  };
}
