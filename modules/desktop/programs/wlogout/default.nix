{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.wlogout;
in

{
  options.modules.desktop.programs.wlogout = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
    layoutSettings = mkOpt (types.nullOr types.str) null;
    styles = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      wlogout
    ];

    home-manager.users."${config.userName}" = mkMerge [
      (mkIf (cfg.layoutSettings != null) {
        xdg.configFile."wlogout/layout" = {
          text = cfg.layoutSettings;
        };
      })
      (mkIf (cfg.styles != null) {
        xdg.configFile."wlogout/style.css" = {
          text = cfg.styles;
        };
      })
    ];
  };
}
