{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readFile concatStringsSep;

  inherit (lib) removePrefix;

  pluginConf = plugins:
    concatStringsSep "\n\n" (map
      (plugin: let
        name = removePrefix "tmuxplugin-" plugin.pname;
      in "run-shell ${plugin}/share/tmux-plugins/${name}/${name}.tmux")
      plugins);

  plugins = with pkgs.tmuxPlugins; [
    copycat
    open
    resurrect
    yank
    vim-tmux-navigator
  ];
in {
  home.shellAliases = {tx = "tmux new-session -A -s $USER";};

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    escapeTime = 10;
    historyLimit = 5000;
    keyMode = "vi";
    shortcut = "a";
    terminal = "tmux-256color";
    baseIndex = 1;
    extraConfig = ''
      ${readFile "${mod}/tmux/tmuxline.conf"}

      ${readFile "${mod}/tmux/tmux.conf"}

      ${pluginConf plugins}
    '';
  };
}
