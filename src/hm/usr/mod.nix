{
  Nrd = from.hm-config {
    inherit (mod) configuration;
    inherit (from.nix) pkgs;
  };
  Modules = let
    inherit (from) term wm;
  in [
    term.helix
    term.git
    term.tmux
    term.aliases
    term.zsh
    term.utils
    term.fonts
  ];
}
