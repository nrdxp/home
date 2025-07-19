{
  pkgs,
  lib,
  ...
}:
let
  wallpaper = "${pkgs.adapta-backgrounds}/share/backgrounds/adapta/tealized.jpg";
  wofi = pkgs.wofi.overrideAttrs (_: {
    preFixup = ''
      gappsWrapperArgs+=(
        --add-flags '-c ${mod}/wofi/config'
        --add-flags '-s ${mod}/wofi/style.css'
      )
    '';
  });
  wofi-emoji = pkgs.wofi-emoji.override { inherit wofi; };
in
{
  home.packages = [
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    wofi
    wofi-emoji
  ];
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };

    listener = [
      # lock
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
      # screen-off
      {
        timeout = 300;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    preload = wallpaper;
    #set the default wallpaper(s) seen on inital workspace(s) --depending on the number of monitors used
    wallpaper = ",${wallpaper}";
  };
  xdg.configFile."hypr/hyprland.conf".text = ''
    exec-once = ${
      toString (
        lib.intersperse "&" [
          "waybar"
          "kitty"
          "qutebrowser"
          "systemctl --user start hypridle"
          "systemctl --user start hyprpaper"
        ]
      )
    }

    source = ${mod}/hyprland.conf


    bind = $mainMod, O, exec, ${wofi}/bin/wofi
    bind = $mainMod, E, exec, ${wofi-emoji}/bin/wofi-emoji

  '';
  xdg.configFile."hypr/hyprlock.conf".source = "${mod}/hyprlock/hyprlock.conf";
  xdg.configFile."waybar".source = "${mod}/waybar";
}
