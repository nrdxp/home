{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix.enable = true;
  programs.helix.languages = {
    language = [
      {
        language-servers = ["marksman" "ltex"];
        name = "markdown";
      }
    ];
    language-server = {
      ltex = {
        command = "ltex-ls";
        config.ltex = {
          dictionary = {en-US = [];};
          disabledRules = {en-US = ["PROFANITY"];};
        };
      };
      yaml-language-server.config.yaml.keyOrdering = false;
      rust-analyzer.config.rust-analyzer.check.command = "clippy";
    };
  };

  programs.helix.settings = {
    theme = "snazzy";
    editor.true-color = true;
    keys.normal = {
      # kakoune like
      w = "extend_next_word_start";
      b = "extend_prev_word_start";
      e = "extend_next_word_end";
      W = "extend_next_long_word_start";
      B = "extend_prev_long_word_start";
      E = "extend_next_long_word_end";

      n = "search_next";
      N = "search_prev";
      A-n = "extend_search_next";
      A-N = "extend_search_prev";
      # ----------------

      # syntax tree maniuplation
      A-j = "expand_selection";
      A-k = "shrink_selection";
      A-h = "select_prev_sibling";
      A-l = "select_next_sibling";
      # ----------------

      C-s = ":w";
      C-q = ":q";
      C-w = "rotate_view";
      C-p = "file_picker";
      C-b = "buffer_picker";
      C-A-n = ":bn";
      C-A-p = ":bp";
      y = ["yank" "yank_joined_to_clipboard"];
    };
    keys.insert.j.j = "normal_mode";
  };
}
