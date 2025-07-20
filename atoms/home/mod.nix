{
  Hello = from.nix.hello;
  Main = from.hm-config {
    inherit (mod) configuration;
    inherit (from.nix) pkgs;
  };
  Shell = from.nix.pkgs.mkShell {
    packages = with from.nix.pkgs; [
      treefmt
      alejandra
      shfmt
      taplo
      nodePackages.prettier
    ];
  };
}
