let
  inherit (deps.from) home;
  inherit (home.nix) pkgs;
in {
  Shell = pkgs.mkShell {
    packages = with pkgs; [
      home.apps.foks
      treefmt
      alejandra
      shfmt
      taplo
      nil
      colmena
      nodePackages.prettier
    ];
  };
}
