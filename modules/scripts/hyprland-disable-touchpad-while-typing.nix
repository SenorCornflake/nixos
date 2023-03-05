{ inputs, config, pkgs, lib, ... }:

with lib;
with lib.my;

mkIf config.modules.desktop.hyprland.enable {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "hyprland_toggle_touchpad_typing" ''
      PATH=${makeBinPath (with pkgs; [ libnotify jq inputs.hyprland.packages.x86_64-linux.default ])} 

      if [[ $(hyprctl getoption input:touchpad:disable_while_typing -j | jq -r ".int") == "1" ]]; then
        hyprctl keyword input:touchpad:disable_while_typing false
        notify-send "Touchpad enabled while typing"
      else
        hyprctl keyword input:touchpad:disable_while_typing true
        notify-send "Touchpad disabled while typing"
      fi
    '')
  ];
}
