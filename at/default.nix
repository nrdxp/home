{repo}: let
  ekala = repo + "/ekala.toml";
  toml = builtins.fromTOML (builtins.readFile ekala);
  f = path: let
    atomdir = repo + "/${path}";
    lockstr = builtins.readFile <| atomdir + "/atom.lock";
    manstr = builtins.readFile <| atomdir + "/atom.toml";
    lock = builtins.fromTOML lockstr;
    manifest = builtins.fromTOML manstr;
    inherit (lock) locker;
    lockexpr =
      import
      <| builtins.fetchGit {
        inherit (locker) rev;
        name = locker.label;
        url = locker.mirror;
        ref = "refs/eka/atoms/${locker.label}/${locker.version}";
      };
  in {
    name = manifest.package.label;
    value = lockexpr atomdir lockstr {
      extraConfig = {
        platform = builtins.currentSystem or "x86_64-linux";
      };
    };
  };
in
  builtins.listToAttrs (map f toml.set.packages)
