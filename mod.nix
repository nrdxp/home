let
  inherit (from.nix) pkgs;
in {
  Shell = pkgs.mkShell {
    packages = with pkgs; [
      from.apps.foks
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
