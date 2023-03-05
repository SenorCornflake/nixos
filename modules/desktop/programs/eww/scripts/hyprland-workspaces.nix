{ inputs,  config, pkgs, lib,  ... }:

with lib;

mkIf config.modules.desktop.hyprland.enable {
  environment.systemPackages = with pkgs; [ socat ];

  modules.scripts.watch-hyprland-workspaces = pkgs.writeShellScriptBin "watch-hyprland-workspaces" ''
    PATH=${lib.makeBinPath (with pkgs; [ gnused eww libnotify socat jq gawk inputs.hyprland.packages.x86_64-linux.default coreutils-full ])}

    ${config.modules.scripts.watch-hyprland-workspaces-python}/bin/watch-hyprland-workspaces-python "$1" "$2" "$3"

    function handle {
      event=$(echo "$1" | awk -F'>>' '{print $1}')
      value=$(echo "$1"| awk -F'>>' '{print $2}')

      if [[ $event == "workspace" ]]; then
          ${config.modules.scripts.watch-hyprland-workspaces-python}/bin/watch-hyprland-workspaces-python "$2" "$3" "$4"
      fi
    }
    socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do handle "$event" "$1" "$2" "$3"; done
  '';

  modules.scripts.watch-hyprland-workspaces-python = pkgs.writeScriptBin "watch-hyprland-workspaces-python" ''
    #!${pkgs.python3Full}/bin/python
    import json
    import sys
    import os


    def e(command): 
        return os.popen(command).read()[:-1]

    if len(sys.argv) < 4:
        print("Need three args, monitor id, active yuck and inactive yuck")
        sys.exit()

    monitor = sys.argv[1]
    active_yuck = sys.argv[2]
    inactive_yuck = sys.argv[3]

    monitors = e("hyprctl -j monitors")
    monitors = json.loads(monitors)

    active_workspace = {}

    for m in monitors:
        if int(m["id"]) == int(monitor):
            active_workspace = m["activeWorkspace"]

    workspaces = e("hyprctl -j workspaces | jq -r \"sort_by(.id)\"")
    workspaces = json.loads(workspaces)

    final_yuck = ""

    for workspace in workspaces:
        if active_workspace["id"] == workspace["id"]:
            yuck = active_yuck.replace("<ID>", str(workspace["id"]))
            yuck = yuck.replace("<NAME>", str(workspace["name"]))
            final_yuck += yuck
        else:
            yuck = inactive_yuck.replace("<ID>", str(workspace["id"]))
            yuck = yuck.replace("<NAME>", str(workspace["name"]))
            final_yuck += yuck

    print(final_yuck)
  '';
}
