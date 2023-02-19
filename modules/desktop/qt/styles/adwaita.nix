{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.qt;
in
{
  home-manager.users."${config.userName}" = {
    qt = mkMerge [
      (mkIf (cfg.theme == "adwaita" || cfg.theme == "adwaita-dark") {
        style = {
          name = cfg.theme;
          package = pkgs.adwaita-qt;
        };
        platformTheme = "gnome";
      })
    ];
  };
}
