{ config, pkgs, lib, ... }:

with lib;
with lib.my;
with builtins;

let
  cfg = config.modules.theme;

  base16 = 
    (if (pathExists (config.dataHome + "/base16.json"))
     then fromJSON (readFile (config.dataHome + "/base16.json"))
     else {
      base00 = "181818";
      base01 = "282828";
      base02 = "383838";
      base03 = "585858";
      base04 = "b8b8b8";
      base05 = "d8d8d8";
      base06 = "e8e8e8";
      base07 = "f8f8f8";
      base08 = "ab4642";
      base09 = "dc9656";
      base0A = "f7ca88";
      base0B = "a1b56c";
      base0C = "86c1b9";
      base0D = "7cafc2";
      base0E = "ba8baf";
      base0F = "a16946";
    });

  inherit (base16) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;

  hex = color: "#" + color;

  hyprland_layout = config.modules.desktop.hyprland.layout;
in

mkIf (cfg.colorscheme == "base16") {
  home-manager.users."${config.userName}" = {
    services.mako = {
      backgroundColor = hex base00;
      borderColor = hex base09;
      textColor = hex base05;
    };
  };

  modules = {
    theme = {
      imperative_wallpaper = true;

      wallpaperBackground = hex base00;
      wallpaperColors = {
        color0 = hex base0A;
        color1 = hex base0B;
        color2 = hex base0C;
        color3 = hex base0D;
        color4 = hex base0E;
        color5 = hex base0F;
      };
    };

    desktop = {
      gtk = {
        theme = "Adwaita-dark";
        iconTheme = "Adwaita";
        cursorTheme = "Adwaita";
      };

      qt = {
        theme = "adwaita-dark";
      };

      hyprland = mkMerge [
        (mkIf (hyprland_layout == null || hyprland_layout == "default") {
          active_border = "rgba(${base07}ff)";
          inactive_border = "rgba(${base01}ff)";
          shadow_color = "rgba(000000ee)";
        })
        (mkIf (hyprland_layout == "trench") {
          active_border = "rgba(${base07}ff)";
          inactive_border = "rgba(${base00}b3)";
          shadow_color = "rgba(000000ee)";
        })
      ];

      programs = {
        tofi = {
          background-color = hex base00;
          text-color = hex base05;
          selection-color = hex base0E;
        };
        rofi.layouts = {
          default = {
            background = hex base00;
            foreground = hex base05;
            alt-bg = hex base01;
            alter-bg = hex base02;
            border = hex base00;
            accent = hex base0E;
          };
          trench = {
            background = base00;
            foreground = base05;
            accent = hex base0E;
          };
        };
        eww.layouts = {
          default = {
            background = hex base0C;
            foreground = hex base00;
            border = hex base00;
          };
          trench = {
            background = base00;
            foreground = base05;
          };
        };
        wlogout.layouts = {
          default = {
            background = hex base00;
            foreground = hex base05;
            accent = hex base0B;
            border = hex base01;
          };
        };
      };

      terminals = {
        kitty.colorscheme = (builtins.readFile (config.dataHome + "/kitty.conf"));
      };
    };

    shell = {
      neovim = {
        colorscheme = "base16";
      };
    };
  };
}
