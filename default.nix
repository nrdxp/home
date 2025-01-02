let
  atom = builtins.fetchGit {
    url = "https://github.com/ekala-project/atom";
    rev = "f56d90e0b80f4b717ded340b89267987cd83c59c";
    shallow = true;
  };

  # atom = import /var/home/nrd/git/github.com/ekala-project/atom;

  home = (import "${atom}/atom-nix/core/importAtom.nix") {} (./atoms + "/home@.toml");
in
  home
