{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.terminals.kitty;
in

mkIf (cfg.layout == null || cfg.layout == "default") {
  home-manager.users."${config.userName}" = {
    programs.kitty = {
      enable = true;
      font.name = "Iosevka Nerd Font Mono";
      font.size = 11;
      settings = {
        adjust_line_height = "100%";
        adjust_column_width = "100%";
        adjust_baseline  = 1;
        disable_ligatures = "always";
        window_padding_width = 10;
        background_opacity = 1;
      };
    };
  };
}
