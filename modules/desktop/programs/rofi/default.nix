{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.rofi;
in

{
  options.modules.desktop.programs.rofi = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
      };
    };
  };
}
