let
  inherit (deps.from.home) nix term;
in {
  Nrd = nix.home-manager.import "modules" {
    inherit (mod) configuration;
    inherit (nix) pkgs;
  };
  Modules = [
    nix.hm.module
    # term.helix
    # term.git
    # term.tmux
    # term.aliases
    # term.zsh
    # term.utils
    # term.fonts
  ];
}
