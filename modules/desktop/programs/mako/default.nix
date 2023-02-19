
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.mako;
in

{
  options.modules.desktop.programs.mako = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libnotify ];

    home-manager.users."${config.userName}" = {
      programs.mako = {
        enable = true;
      };
    };
  };
}