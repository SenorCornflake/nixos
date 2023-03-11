
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.mako;
in

mkIf (cfg.layout == "trench") {
  home-manager.users."${config.userName}" = {
    services.mako = {
      height = 300;
      width = 300;
      borderSize = 2;
      anchor = "bottom-left";
      defaultTimeout = 5000;
      ignoreTimeout = false;
      borderRadius = 10;
      icons = false;
      layer = "overlay";
      padding = "10";
      margin = "10";
      font = "Iosevka Nerd Font 11";
      format = "<b>%a: %s</b>\\n%b";
    };
  };
}
