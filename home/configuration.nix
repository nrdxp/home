{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nrd";
  home.homeDirectory = "/var/home/nrd";
  nixpkgs.config.allowUnfree = true;

  imports = [
    atom.term.helix
    atom.term.git
    atom.term.tmux
    atom.term.aliases
    atom.term.zsh
    atom.term.utils
    atom.term.fonts
  ];

  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
  ];

  nix.registry.pkgs.to = {
    type = "path";
    path = pkgs.path;
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
