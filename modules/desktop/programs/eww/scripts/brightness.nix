{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ inotify-tools ];

  modules.scripts.brightness = (pkgs.writeShellScriptBin "brightness" ''
    brightness=$(brightnessctl i | grep Current | awk '{print $4}' | sed 's/(//' | sed 's/)//')
    echo $brightness

    inotifywait /sys/class/backlight/intel_backlight/brightness -m -q -e modify | while read line; do
      brightness=$(brightnessctl i | grep Current | awk '{print $4}' | sed 's/(//' | sed 's/)//')
      echo $brightness
    done
  '');
}
