{
  Hello = from.nix.hello;
  Main = from.hm-config {
    inherit (mod) configuration;
    inherit (from.nix) pkgs;
  };
  DefaultImports =
    let
      inherit (from) term wm;
    in
    [
      term.helix
      term.git
      term.tmux
      term.aliases
      term.zsh
      term.utils
      term.fonts
      wm.hyprland
    ];

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
