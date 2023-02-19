{ inputs, config, lib, pkgs, ... }:

# TODO: FINISH THIS PLEASE
{
  # modules.scripts.hyprland-workspaces = (pkgs.writeShellScriptBin "hyprland-workspaces" ''
  #   PATH=${lib.makeBinPath (with pkgs; [ libnotify socat jq gawk inputs.hyprland.packages.x86_64-linux.default coreutils-full ])}
  #   function handle {
  #     event=$(echo $1 | awk -F'>>' '{print $1}')
  #     value=$(echo $1 | awk -F'>>' '{print $2}')

  #     if [[ $event == "workspace" ]]; then
  #       hyprctl -j workspaces | jq -r "sort_by(.id) | .[].name" | tr "\n" " "
  #       echo
  #       notify-send "$(hyprctl -j workspaces | jq -r "sort_by(.id) | .[].name" | tr "\n" " ")"
  #     fi
  #   }
  #   notify-send "$HYPRLAND_INSTANCE_SIGNATURE"
  #   socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done
  # '');

  #modules.scripts.hyprland-workspaces = (pkgs.writeShellScriptBin "hyprland-workspaces" ''
  #  PATH=${lib.makeBinPath (with pkgs; [ libnotify socat jq gawk inputs.hyprland.packages.x86_64-linux.default coreutils-full gnused ])}
  #  hyprctl -j workspaces | jq -r "sort_by(.id) | .[].name" | tr "\n" " " | sed -e 's/\ *$//g'
  #'');
  
  modules.scripts.watch-hyprland-workspaces = (pkgs.writeShellScriptBin "watch-hyprland-workspaces" ''
    PATH=${lib.makeBinPath (with pkgs; [ procps libnotify socat jq gawk inputs.hyprland.packages.x86_64-linux.default coreutils-full ])}
    function handle {
      event=$(echo $1 | awk -F'>>' '{print $1}')
      value=$(echo $1 | awk -F'>>' '{print $2}')

      if [[ $event == "workspace" ]]; then
        pkill -RTMIN+8 waybar
      fi
    }
    socat -u UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock - | while read -r event; do handle $event; done
  '');
}
