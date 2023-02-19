{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bc ];
  modules.scripts.volume = (pkgs.writeShellScriptBin "volume" ''
    function display_volume() {
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
        volume=$(echo "$volume*100" | bc | sed 's/.00//')
        mute=$(pactl get-sink-mute $(pactl get-default-sink) | sed "s/Mute: //g")

        if [[ $mute == "yes" ]]; then
            echo "muted"
        else
            echo $volume
        fi
    }
    display_volume

    pactl subscribe | while read line; do
        if [[ $(echo "$line" | grep change) ]]; then
            display_volume
        fi
    done
  '');
}
