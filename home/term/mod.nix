{
  Helix = mod.helix;
  Git = mod.git;
  Tmux = mod.tmux;
  Zsh = mod.zsh;
  Aliases.home.shellAliases = {
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
    nepl = "n repl ${pre.pkgs.path}#legacyPackages.${pre.pkgs.system}";
    srch = "ns ${pre.pkgs.path}";
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
}
