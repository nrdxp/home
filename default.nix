let
  atom = fetchTarball {
    url = "https://github.com/ekala-project/atom/archive/568552c52f0e209f3978c5af7d686b952117d6e1.tar.gz";
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
  } (./atoms + "/home@.toml");
  hosts = (import "${atom}/atom-nix/core/importAtom.nix") {
    inherit remoteUrl;
  } (./atoms + "/hosts@.toml");
in
{
  inherit home hosts;
}
