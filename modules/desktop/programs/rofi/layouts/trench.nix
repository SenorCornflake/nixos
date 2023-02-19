{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.rofi;
  layout = config.modules.desktop.programs.rofi.layouts.trench;

  l = config.home-manager.users."${config.userName}".lib.formats.rasi.mkLiteral;

  hex = color: "#" + color;
in
{
  options.modules.desktop.programs.rofi.layouts.trench = {
    background = mkOpt types.str "000000";
    foreground = mkOpt types.str "ffffff";
    accent = mkOpt types.str "#ffff00";
  };
  config = mkIf (cfg.layout == "trench") {
    home-manager.users."${config.userName}" = {
      programs.rofi = {
        location = "left";
        extraConfig = {
          font = "Iosevka Nerd Font 11";
          show-icons = true;
          icon-theme = "Adwaita";
        };
        theme = {
          "*" = {
            background-color = l "rgba(${hexToRGBString "," layout.background}, 0.7)";
            text-color = l (hex layout.foreground);
          };
          window = {
            width = l "40%";
            height = l "100%";
            border = l "0px 2px 0px 0px";
            border-color = l "rgba(${hexToRGBString "," layout.background}, 0.9)";
            children = map l [ "inputbar" "listview" ];
            spacing = 0;
          };

          listview = {
            padding = l "10px 0px 0px 0px";
            fixed-height = true;
            columns = 1;
            spacing = l "0px";
            scrollbar = true;
          };

          inputbar = {
            padding = l "0";
            spacing = 0;
            children = map l [ "prompt" "entry" "num-filtered-rows" ];
            background-color = l "rgba(${hexToRGBString "," layout.background}, 0.7)";
            border-color = l "rgba(${hexToRGBString "," layout.background}, 0.7)";
            border = l "0px 0px 2px 0px";
          };

          num-filtered-rows = {
            padding = l "10px";
            vertical-align = l "0.5";
            background-color = l "#00000000";
          };

          entry = {
            padding = l "10px";
            vertical-align = l "0.5";
            expand = true;
            background-color = l "#00000000";
          };

          prompt = {
            text-color = l layout.accent;
            padding = l "10px";
            background-color = l "#00000000";
            vertical-align = l "0.5";
          };

          scrollbar = {
            handle-width = l "2px";
            background-color = l "#00000000";
            handle-color = l layout.accent;
          };

          element = {
            padding = l "10px";
            background-color = l "#00000000";
            margin = l "0px 10px 10px 10px";
          };

          "element selected" = {
            background-color = l "rgba(${hexToRGBString "," layout.background}, 0.7)";
            border = l "2px 2px 2px 2px";
            border-radius = l "10px";
            border-color = l "rgba(${hexToRGBString "," layout.foreground}, 0.1)";
          };

          element-text = {
            vertical-align = l "0.5";
            background-color = l "#00000000";
          };

          "element-text selected" = {
            background-color = l "#00000000";
          };

          element-icon = {
            padding = l "0px 5px";
            background-color = l "#00000000";
          };

          "element-icon selected" = {
            background-color = l "#00000000";
          };
        };
      };
    };
  };
}
