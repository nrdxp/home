let
  atom = import (builtins.fetchGit {
    url = "https://github.com/ekala-project/atom";
    rev = "725d2fe9ceed70a5163faf9d0165b8df217c5785";
    shallow = true;
  });

  home = atom.importAtom {} (./. + "/home@.toml");
in
  home
