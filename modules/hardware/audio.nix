{ config, lib, pkgs, ... }:

with lib;
with lib.my;

{
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    environment.systemPackages = with pkgs; [ pulseaudio ];
  };
}
