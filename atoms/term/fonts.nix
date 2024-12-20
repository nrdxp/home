{pkgs, ...}: let
  nerdfonts = pkgs.nerdfonts.override {
    fonts = ["DejaVuSansMono"];
  };
in {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.dejavu-sans-mono
    pkgs.powerline-fonts
    pkgs.dejavu_fonts
    pkgs.nanum
    pkgs.nanum-gothic-coding
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono Nerd Font Complete Mono"
      "DejaVu Sans Mono for Powerline"
    ];

    sansSerif = ["DejaVu Sans"];
  };
}
