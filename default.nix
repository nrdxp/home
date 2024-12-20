let
  atom = import (builtins.fetchGit {
    url = "https://github.com/ekala-project/atom";
    rev = "713a3adffa94e7d64b209b9073ba2fa73080bcb3";
    shallow = true;
  });

  home = atom.importAtom {} (./atoms + "/home@.toml");
in
  home
