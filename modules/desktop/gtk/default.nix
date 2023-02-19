{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.gtk;
in

{
  options.modules.desktop.gtk = {
    enable = mkBoolOpt false;
    theme = mkOpt types.str "Adwaita-dark";
    iconTheme = mkOpt types.str "Adwaita";
    cursorTheme = mkOpt types.str "Adwaita";
    cursorSize = mkOpt types.int 24;
    font = mkOpt types.str "Noto Sans, 10";
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs; [
      noto-fonts
    ];

    home-manager.users."${config.userName}" = {
      gtk = {
        enable = true;
        font.name = cfg.font;
        gtk2.configLocation = "${config.configHome}/gtk-2.0/gtkrc";
        cursorTheme.size = cfg.cursorSize;
      };
    };
  };
}
