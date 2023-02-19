{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.rofi;
  layout = config.modules.desktop.programs.rofi.layouts.default;

  l = config.home-manager.users."${config.userName}".lib.formats.rasi.mkLiteral;
in
{
  options.modules.desktop.programs.rofi.layouts.default = {
    background = mkOpt types.str "#000000";
    foreground = mkOpt types.str "#ffffff";
    alt-bg = mkOpt types.str "#111111";
    alter-bg = mkOpt types.str "#222222";
    border = mkOpt types.str "#000000";
    accent = mkOpt types.str "#ffff00";
  };
  config = mkIf (cfg.layout == null || cfg.layout == "default") {
    home-manager.users."${config.userName}" = {
      programs.rofi = {
        location = "center";
        extraConfig = {
          font = "Iosevka Nerd Font 12";
          show-icons = true;
          icon-theme = "Adwaita";
        };
        theme = {
          "*" = {
            background-color = l layout.background;
            border-color = l layout.border;
            text-color = l layout.foreground;
          };
          window = {
            width = l "40%";
            height = l "50%";
            border = l "1px";
            border-color = l layout.border;
            children = map l [ "inputbar" "listview" ];
            spacing = 0;
          };

          listview = {
            fixed-height = true;
            columns = 1;
            spacing = l "0px";
            scrollbar = true;
          };

          inputbar = {
            padding = l "0";
            spacing = 0;
            children = map l [ "prompt" "entry" "num-filtered-rows" ];
          };

          num-filtered-rows = {
            padding = l "10px";
            vertical-align = l "0.5";
            background-color = l layout.alt-bg;
          };

          entry = {
            padding = l "10px";
            background-color = l layout.alt-bg;
            vertical-align = l "0.5";
            expand = true;
          };

          prompt = {
            text-color = l layout.accent;
            padding = l "10px";
            background-color = l layout.alter-bg;
            vertical-align = l "0.5";
            border-color = l layout.border;
            border = l "0 1px 0 0";
          };

          scrollbar = {
            handle-width = l "1px";
            background-color = l layout.background;
            handle-color = l layout.accent;
          };

          element = {
            padding = l "10px";
            border = l "1px 0px 0px 0px";
            border-color = l layout.border;
          };

          "element selected" = {
            background-color = l layout.alt-bg;
          };

          element-text = {
            vertical-align = l "0.5";
          };

          "element-text selected" = {
            background-color = l "inherit";
          };

          element-icon = {
            padding = l "0px 5px";
          };

          "element-icon selected" = {
            background-color = l "inherit";
          };
        };
      };
    };
  };
}
