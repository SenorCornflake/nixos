{ config, pkgs, lib, ... }:
with lib;
with lib.my;

let 
  cfg = config.modules.desktop.gnome;
in

{
  options.modules.desktop.gnome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}