{ inputs,  config, pkgs, lib,  ... }:

{
  environment.systemPackages = with pkgs; [ socat ];

  modules.scripts.hyprland-title = pkgs.writeShellScriptBin "hyprland-title" ''
    PATH=${lib.makeBinPath (with pkgs; [ gnused eww libnotify socat jq gawk inputs.hyprland.packages.x86_64-linux.default coreutils-full ])}

    title=$(hyprctl activewindow -j | jq .title -r | sed 's/\\n//')
    echo "$title"

    function handle {
      event=$(echo $1 | awk -F'>>' '{print $1}')
      value=$(echo $1 | awk -F'>>' '{print $2}')

      if [[ $event == "activewindow" ]]; then
        title=$(hyprctl activewindow -j | jq .title -r | sed 's/\\n//')
        echo "$title"
      fi
    }
    socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do handle $event; done
  '';
}
