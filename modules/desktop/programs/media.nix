
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.media;
in

{
  options.modules.desktop.programs.media = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mpv
      vlc
      nomacs
      feh
      audacity
    ];
  };
}
