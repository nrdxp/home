{
  Helix = mod.helix;
  Git = mod.git;
  Tmux = mod.tmux;
  Zsh = mod.zsh;
  Fonts = mod.fonts;
  Utils = {
    pkgs,
    lib,
    ...
  }:
    with pkgs; {
      home.packages =
        [
          file
          less
          ncdu
          gopass
          tig
          tokei
          wget
          binutils
          coreutils
          curl
          direnv
          dnsutils
          fd
          git
          bottom
          jq
          nix-index
          nmap
          ripgrep
          whois
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          util-linux
          iputils
        ];
      programs.gpg.enable = true;
      services.gpg-agent.enable = true;
      services.gpg-agent.enableSshSupport = true;
      services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
    };
  Aliases = {pkgs, ...}: {
    home.shellAliases = {
      v = "$EDITOR";
      pass = "gopass";

      # quick cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # git
      g = "git";

      # grep
      grep = "rg";
      gi = "grep -i";

      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      nepl = "n repl pkgs#legacyPackages.${pkgs.system}";
      srch = "ns pkgs";
      orch = "ns override";

      # top
      top = "btm";

      # systemd
      ctl = "systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      jtl = "journalctl";
    };
  };
}
