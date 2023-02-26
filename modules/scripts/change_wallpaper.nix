{ inputs, config, pkgs, lib, ... }:

let
  nix-wallpaper = inputs.nix-wallpaper.packages.${builtins.currentSystem}.default.override {
    logoColors = cfg.wallpaperColors;
    backgroundColor = cfg.wallpaperBackground;
  };

  cfg = config.modules.theme;
in
{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "set_wallpaper" ''
      ${if config.modules.theme.imperative_wallpaper then ''
        wallpaper=$(cat $XDG_DATA_HOME/imperative_wallpaper)
      '' else ''
        wallpaper=$(cat $XDG_DATA_HOME/wallpaper)
      ''}
      if [[ $(pgrep swaybg) ]]; then
        pkill swaybg
        swaybg -m fill -i "$wallpaper" &
      else
        swaybg -m fill -i "$wallpaper" &
      fi
    '')
    (writeShellScriptBin "change_wallpaper" ''
      if [[ $1 == "" ]]; then
        wallpaper=$(echo "$(ls ~/wallpapers)
      nix-wallpaper" | rofi -dmenu -p "Wallpaper: ")
      elif [[ $1 = "random" ]]; then
        wallpaper=$(ls ~/wallpapers | shuf -n 1)
      fi

      if [[ $1 == "update" ]]; then
        wallpaper=$(cat $XDG_DATA_HOME/imperative_wallpaper)
        if [[ $(echo "$wallpaper" | grep "nix-wallpaper") ]]; then
          echo -n "${nix-wallpaper}/share/wallpapers/nixos-wallpaper.png" > $XDG_DATA_HOME/imperative_wallpaper
        fi
        exit
      fi

      if [[ $wallpaper == "" ]]; then
        exit
      elif [[ $wallpaper == "nix-wallpaper" ]]; then
        echo -n "${nix-wallpaper}/share/wallpapers/nixos-wallpaper.png" > $XDG_DATA_HOME/imperative_wallpaper
      else
        echo -n "$HOME/wallpapers/$wallpaper" > $XDG_DATA_HOME/imperative_wallpaper
        set_wallpaper
      fi
    '')
  ];
}
