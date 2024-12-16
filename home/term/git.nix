{
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.git.extraConfig = builtins.fromTOML (builtins.readFile "${mod}/git.toml");
  programs.git.includes = [{
    condition = "gitdir:~/work/**";
    contents.user.email = "tim.deherrera@iohk.io";
  }];
}