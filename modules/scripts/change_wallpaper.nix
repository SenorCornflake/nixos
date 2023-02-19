{ config, pkgs, lib, ... }:

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
        swaybg -m fill -i "$HOME/wallpapers/$wallpaper" &
      else
        swaybg -m fill -i "$HOME/wallpapers/$wallpaper" &
      fi
    '')
    (writeShellScriptBin "change_wallpaper" ''
        wallpaper=$(ls ~/wallpapers | rofi -dmenu -p "Wallpaper: ")

        if [[ $wallpaper == "" ]]; then
          exit
        else
          echo -n "$wallpaper" > $XDG_DATA_HOME/imperative_wallpaper
          set_wallpaper
        fi
      '')
  ];
}
