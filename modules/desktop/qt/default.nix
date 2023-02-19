{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.qt;
in
{
  options.modules.desktop.qt = {
    theme = mkOpt types.str "adwaita-dark";
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      qt = {
        enable = true;
      };
    };
  };
}
