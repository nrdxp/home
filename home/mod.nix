{
  pkgs = atom.nixpkgs {};
  Main = atom.hm-config {inherit (mod) pkgs configuration;};
  Term = mod.term;
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
