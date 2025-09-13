{
  imports = [
    (
      {pkgs, ...}: {
        home.packages = [pkgs.ghq];
      }
    )
  ];
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.git.extraConfig = builtins.fromTOML (builtins.readFile "${mod}/git.toml");
  programs.git.includes = [
    {
      condition = "gitdir:~/work/**";
      contents.user.email = "tdeherrera@anduril.com";
    }
  ];
}
