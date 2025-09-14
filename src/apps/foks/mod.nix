let
  inherit (from.nix.pkgs) callPackage;
in {
  Pkg = (callPackage from.foks {}).overrideAttrs (_: {
    postInstall = ''
      ln -s $out/bin/{foks,git-remote-foks}
    '';
  });
}
