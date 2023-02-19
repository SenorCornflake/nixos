{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.terminals.wezterm;
in

{
  options.modules.desktop.terminals.wezterm = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
    colorscheme = mkOpt (types.nullOr types.str) null;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wezterm
    ];

    home-manager.users."${config.userName}" = {
      xdg.configFile."wezterm/wezterm.lua" = {
        target = "wezterm/wezterm.lua";
        text = ''
          local wezterm = require "wezterm"
          return {
            font = wezterm.font 'Iosevka Nerd Font',
            enable_tab_bar = false,
            font_size = 11.0,
            color_scheme_dirs = { "~/.local/share/wezterm/colors" }
          }
        '';
      };
    };
  };
}
