let
  inherit (deps) from pins;
  inherit (from.home.nix.pkgs) callPackage;
  inherit (pins) foks;
in {
  Pkg = (callPackage foks.src {}).overrideAttrs (_: {
    postInstall = ''
      ln -s $out/bin/{foks,git-remote-foks}
    '';
  });
}
