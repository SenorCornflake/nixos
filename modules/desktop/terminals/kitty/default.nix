{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.terminals.kitty;
in

{
  options.modules.desktop.terminals.kitty = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
    colorscheme = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      programs.kitty = {
        enable = true;
        settings = {
          scrollback_lines = 50000;
          cursor_blink_interval = 1;
          enable_audio_bell = "no";
          confirm_os_window_close = 0;
          bold_font = "auto";
          bold_italic_font = "auto";
          italic_font = "auto";
        };
        extraConfig = if cfg.colorscheme == null then "" else cfg.colorscheme;
      };
    };
  };
}
