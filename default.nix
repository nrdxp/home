let
  atom = fetchTarball {
    url = "https://github.com/ekala-project/atom/archive/8069028758c56d5f090ac48c70d22806c6910197.tar.gz";
  };

  f = let
    Import =
      {
        remoteUrl = "https://github.com/nrdxp/home.git";
      }
      |> import "${atom}/atom-nix/core/importAtom.nix";
  in
    path: {
      name = baseNameOf path;
      value = Import path;
    };
in
  builtins.listToAttrs
  <| map f [
    ./atoms/home
    ./atoms/nix
    ./atoms/hosts
  ]
