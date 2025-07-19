{
  pkgs = get.nixpkgs { };
  Main = get.hm-config { inherit (mod) pkgs configuration; };
  Shell = mod.pkgs.mkShell {
    packages = with mod.pkgs; [
      treefmt
      alejandra
      shfmt
      taplo
      nodePackages.prettier
    ];
  };
}
