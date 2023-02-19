{ config, pkgs, lib, ...}:

with pkgs;
with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.eww;
in

{
  options.modules.desktop.programs.eww = {
    enable = mkBoolOpt false;
    yuck = mkOpt types.str '''';
    scss = mkOpt types.str '''';
    layout = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (eww.override {
        withWayland = true;
      })
    ];

    home-manager.users."${config.userName}" = {
      xdg.configFile."eww/eww.yuck" = {
        target = "eww/eww.yuck";
        text = cfg.yuck;
      };
      xdg.configFile."eww/eww.scss" = {
        target = "eww/eww.scss";
        text = cfg.scss;
      };
    };
  };
}
