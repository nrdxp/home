{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;
in {
  home = {
    sessionVariables = let
      fd = "${pkgs.fd}/bin/fd -H";
    in {
      BAT_PAGER = "less";
      SKIM_DEFAULT_OPTIONS = "--bind=alt-k:up,alt-j:down";
      SKIM_ALT_C_COMMAND = let
        alt_c_cmd = pkgs.writeScriptBin "cdr-skim.zsh" ''
          #!${pkgs.zsh}/bin/zsh
          ${fileContents "${mod}/zsh/cdr-skim.zsh"}
        '';
      in "${alt_c_cmd}/bin/cdr-skim.zsh";
      SKIM_DEFAULT_COMMAND = fd;
      SKIM_CTRL_T_COMMAND = fd;
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      os = "nixos-rebuild --use-remote-sudo";
      oss = "os switch";
      osb = "os build";

      df = "df -h";
      du = "du -h";

      exa = "eza";
      ls = "exa";
      l = "ls -lhg --git";
      la = "l -a";
      t = "l -T";
      ta = "la -T";

      ps = "${pkgs.procs}/bin/procs";

      rz = "exec zsh";
    };

    packages = with pkgs; [
      bat
      bzip2
      (pkgs.eza or pkgs.exa)
      gitAndTools.hub
      gzip
      lrzip
      p7zip
      unzip
      unrar
      procs
      xz
      skim
    ];
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    completionInit = "";

    history.size = 10000;

    initExtraFirst = ''
      if [[ -r "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh" ]]; then
        source "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh"
      fi
      setopt incappendhistory
      setopt sharehistory
      setopt histignoredups
      setopt histfcntllock
      setopt histreduceblanks
      setopt histignorespace
      setopt histallowclobber
      setopt autocd
      setopt cdablevars
      setopt nomultios
      setopt pushdignoredups
      setopt autocontinue
      setopt promptsubst

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [[ $TTY =~ /dev/tty ]]; then
        source ${mod}/zsh/p10k-ascii.zsh
      else
        source ${mod}/zsh/p10k.zsh
      fi
    '';

    initExtra = let
      zshrc = fileContents "${mod}/zsh/zshrc";

      sources = with pkgs; [
        "${mod}/zsh/cdr.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/urltools/urltools.plugin.zsh"
        "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
        "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "${zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
        "${pkgs.zsh-better-npm-completion}/share/zsh-better-npm-completion"
      ];

      source = map (source: "source ${source}") sources;

      functions = pkgs.stdenv.mkDerivation {
        name = "zsh-functions";
        src = "${mod}/zsh/functions";

        ripgrep = "${pkgs.ripgrep}";
        man = "${pkgs.man}";
        exa = "${pkgs.eza or pkgs.exa}";

        installPhase = let
          basename = "\${file##*/}";
        in ''
          mkdir $out

          for file in $src/*; do
            substituteAll $file $out/${basename}
            chmod 755 $out/${basename}
          done
        '';
      };

      plugins = concatStringsSep "\n" source;

      completions = let
        completionCommand = pkg: args: let
          cmd = pkg.meta.mainProgram or pkg.pname;
        in
          pkgs.runCommandNoCC "zsh-${cmd}-completion" {}
          ''
            mkdir -p $out/share/zsh/vendor-completions
            ${pkg}/bin/${cmd} ${toString args} > $out/share/zsh/vendor-completions/_${cmd}
          '';
      in
        pkgs.symlinkJoin {
          name = "user-zsh-completions";
          paths = map (drv: "${drv}/share/zsh") (with pkgs; [
            kubectl
            cargo
            colmena
            zsh-completions
            systemd
            (completionCommand kubernetes-helm ["completion" "zsh"])
          ]);
        };

      bashCompletion = ''
        autoload -U bashcompinit && bashcompinit
        complete -o nospace -C ${pkgs.awscli}/bin/aws_completer aws
        complete -o nospace -C ${pkgs.opentofu}/bin/tofu tofu
        complete -o nospace -C ${pkgs.opentofu}/bin/tofu terragrunt
      '';
    in ''
      fpath+=( ${functions} ${completions}/{site-functions,vendor-completions} )

      ${plugins}

      autoload -Uz ${functions}/*(:t)

      ${zshrc}

      ${bashCompletion}

      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
      source ${pkgs.skim}/share/skim/key-bindings.zsh

      # needs to remain at bottom so as not to be overwritten
      bindkey jj vi-cmd-mode
    '';
  };
}
