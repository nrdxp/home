{
  pkgs = atom.nixpkgs {};
  Main = atom.hm-config {inherit (mod) pkgs configuration;};
  Term = mod.term;
}
