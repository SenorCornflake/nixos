{ inputs, config, lib, pkgs, ... }:

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
    wallpaperBackground = mkOpt types.str "#ffffff";
    wallpaperColors = mkOpt (types.attrsOf types.str) (rec {
      color0 = "#7ebae4";
      color1 = "#5277c3";
      color2 = color0;
      color3 = color1;
      color4 = color0;
      color5 = color1;
    });
  };

  config = {
    home-manager.users."${config.userName}" = {
      xdg.dataFile."wallpaper" = {
        text = cfg.wallpaper;
      };
    };
  };
}
