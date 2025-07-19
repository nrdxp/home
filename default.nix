let
  atom = fetchTarball {
    url = "https://github.com/ekala-project/atom/archive/6a0c19bdb182327abef4d06fb1f5541e27cfe797.tar.gz";
  };

  # atom = import /var/home/nrd/git/github.com/ekala-project/atom;

  home = (import "${atom}/atom-nix/core/importAtom.nix") {
    remoteUrl = "https://github.com/nrdxp/home.git";
  } (./atoms + "/home@.toml");
in
home
