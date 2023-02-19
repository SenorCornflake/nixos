{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gammastep
    (writeShellScriptBin "restore_nightmode_state" ''
      PATH=${lib.makeBinPath (with pkgs; [coreutils procps gammastep])}

      file=$XDG_DATA_HOME/nightmode

      if [[ ! -f $file ]]; then
        echo -n "disabled" > $file
      elif [[ $(cat $file) == "enabled" ]]; then
        pkill gammastep
        gammastep -O 4500 &
      else
        pkill gammastep
      fi
    '')
  ];
}
