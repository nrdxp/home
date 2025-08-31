let
  atom = fetchTarball {
    url = "https://github.com/ekala-project/atom/archive/8069028758c56d5f090ac48c70d22806c6910197.tar.gz";
  };

  remoteUrl = "https://github.com/nrdxp/home.git";
  # testPublished = fetchGit {
  #   url = remoteUrl;
  #   rev = "f19aa4fb4dbb4846ae93c9a9ec23fdd70d2a193f";
  #   ref = "refs/eka/atoms/home/0.1.1";
  #   shallow = true;
  # };

  home = (import "${atom}/atom-nix/core/importAtom.nix") {
    inherit remoteUrl;
  } ./atoms/home;
  hosts = (import "${atom}/atom-nix/core/importAtom.nix") {
    inherit remoteUrl;
  } ./atoms/hosts;
in
{
  inherit home hosts;
}
