{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.tofi;
in

{
  options.modules.desktop.programs.tofi = {
    enable = mkBoolOpt false;
    extraConfig = mkOpt types.str "";
    layout = mkOpt (types.nullOr types.str) null;
    background-color = mkOpt types.str "#000000";
    text-color = mkOpt types.str "#ffffff";
    selection-color = mkOpt types.str "#00ff00";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tofi ];

    home-manager.users."${config.userName}" = {
      xdg.configFile."tofi/config" = {
        text = ''
          background-color = ${cfg.background-color}
          text-color = ${cfg.text-color}
          selection-color = ${cfg.selection-color}
        '' + cfg.extraConfig;
      };
    };
  };
}