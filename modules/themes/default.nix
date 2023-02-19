{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.theme;
in

{
  options.modules.theme = {
    layout = mkOpt types.str "default";
    colorscheme = mkOpt types.str "default";
    wallpaper = mkOpt types.str "";
    imperative_wallpaper = mkBoolOpt false;
  };

  config = {
    home-manager.users."${config.userName}" = {
      xdg.dataFile."wallpaper" = {
        text = cfg.wallpaper;
      };
    };
  };
}
