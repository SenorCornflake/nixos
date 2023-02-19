{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gammastep
    (writeShellScriptBin "toggle_nightmode" ''
      PATH=${lib.makeBinPath (with pkgs; [procps coreutils gammastep])}

      file=$XDG_DATA_HOME/nightmode

      if [[ ! -f $file ]]; then
        echo -n "enabled" > $file
        pkill gammastep
        gammastep -O 4500 &
      elif [[ $(cat $file) == "enabled" ]]; then
        pkill gammastep
        echo -n "disabled" > $file
      else
        pkill gammastep
        gammastep -O 4500 &
        echo -n "enabled" > $file
      fi
    '')
  ];
}
