let
  inherit (deps.from.home) users;
in {
  Micro = mod.micro;

  nrd = {
    pkgs,
    lib,
    config,
    ...
  }: {
    users.mutableUsers = false;
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    nixpkgs.flake.setNixPath = false;
    nixpkgs.flake.setFlakeRegistry = false;
    nix = {
      inherit (users.nrd.config.nix) registry;
    };

    home-manager.users.nrd = {
      home.stateVersion = "25.05";

      imports = users.modules;

      programs.zsh.initContent = lib.mkAfter ''
        hash -d \
          xp=~hub/nrdxp
      '';
    };

    systemd.tmpfiles.rules = [
      "L+ /etc/nixos - - - - /srv/git/github.com/nrdxp/nrdos"
      "L+ /home/nrd/git - nrd users - /srv/git"
      "L+ /home/nrd/work - nrd users - git/github.com/input-output-hk"
    ];

    users.users.nrd = {
      isNormalUser = true;
      extraGroups =
        [
          "wheel"
          "keys"
          "input"
          "video"
          "audio"
        ]
        ++ lib.optional (config.virtualisation.docker.enable) "docker"
        ++ lib.optional (config.users.groups ? media) "media"
        ++ lib.optional (config.virtualisation.libvirtd.enable) "libvirtd"
        ++ lib.optional (config.networking.networkmanager.enable) "networkmanager"
        ++ lib.optional (config.programs.adb.enable) "adbusers";
      hashedPassword = "$6$wvQOaBh8ZDb6sChU$JEGVARG31.mwbIwzzsLyFGTaKBmtE5Xlgq2UE3HhKjT2C6Bf5vy/mSgvFf52iGP0aNWUIA31JzcihEAImlM5I1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+qICZVV3G5T9V4KsAaI2cvNjaSuNwZyPCv6enKxqmK tim@nrd.sh"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmt47rzPKo3pESGUtlwleJD89Iz9i4T7nzImGu5TSz5 tdeherrera@tdeherrera-5690-nixos"
      ];
    };

    services.xserver.displayManager.autoLogin.user = "nrd";
  };
}
