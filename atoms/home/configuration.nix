{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nrd";
  home.homeDirectory = "/var/home/nrd";
  nixpkgs.config.allowUnfree = true;

  imports = let
    inherit (get) term wm;
  in [
    term.helix
    term.git
    term.tmux
    term.aliases
    term.zsh
    term.utils
    term.fonts
    wm.hyprland
  ];

  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
  ];

  nix.registry.pkgs.to = {
    type = "path";
    path = pkgs.path;
  };

  # link application desktop files to the user local directory
  home.activation = {
    linkDesktopApplications =
      lib.hm.dag.entryAfter ["writeBoundary"]
      ''
        mkdir -p ~/.local/share/applications
        for app in ~/.nix-profile/share/applications/*; do
          ln -sf $app ~/.local/share/applications/
        done
      '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
