{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.waybar;
in

{
  options.modules.desktop.programs.waybar = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "graphical-session.target";
        };
      };
    };
  };
}
