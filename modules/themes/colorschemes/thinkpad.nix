{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.theme;

  colors = {
    background = "010101";
    foreground = "bbbbbb";
    red-0 = "110000";
    red-1 = "220000";
    red-2 = "aa0000";
  };

  hex = color: "#" + color;
in

mkIf (cfg.colorscheme == "thinkpad") {
  home-manager.users."${config.userName}" = {
    programs.mako = {
      backgroundColor = hex colors.red-1;
      borderColor = hex colors.red-2;
      textColor = hex colors.foreground;
    };
  };

  modules = {
    theme = {
      imperative_wallpaper = true;
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

      hyprland = {
        active_border = "rgba(${colors.red-1}ff)";
        inactive_border = "rgba(${colors.red-0}ff)";
        shadow_color = "rgba(000000ee)";
      };

      programs = {
        tofi = {
          background-color = hex colors.background;
          text-color = hex colors.red-2;
          selection-color = hex colors.foreground;
        };
        rofi.layouts = {
          default = {
            background = hex colors.background;
            foreground = hex colors.foreground;
            alt-bg = hex colors.red-0;
            alter-bg = hex colors.red-1;
            accent = hex colors.red-2;
            border = hex colors.background;
          };
        };
        eww.layouts = {
          default = {
            background = hex colors.background;
            foreground = hex colors.foreground;
            border = hex colors.red-0;
          };
          trench = {
            background = colors.background;
            foreground = colors.foreground;
          };
        };
        wlogout.layouts = {
          default = {
            background = hex colors.background;
            foreground = hex colors.foreground;
            accent = hex colors.red-2;
            border = hex colors.red-0;
          };
        };
      };

      terminals = {
        kitty.colorscheme = ''
          # Base16 base16-black-metal - kitty color config
          # Scheme by Neovim
          background #000000
          foreground #c1c1c1
          selection_background #c1c1c1
          selection_foreground #000000
          url_color #c1c1c1
          cursor #c1c1c1
          active_border_color #333333
          inactive_border_color #121212
          active_tab_background #000000
          active_tab_foreground #c1c1c1
          inactive_tab_background #121212
          inactive_tab_foreground #c1c1c1
          tab_bar_background #121212

          # normal
          color0 #000000
          color1 #5f8787
          color2 #dd9999
          color3 #a06666
          color4 #888888
          color5 #999999
          color6 #aaaaaa
          color7 #c1c1c1

          # bright
          color8 #333333
          color9 #aaaaaa
          color10 #121212
          color11 #222222
          color12 #c1c1c1
          color13 #c1c1c1
          color14 #aaaaaa
          color15 #c1c1c1
        '';
      };
    };

    shell = {
      neovim = {
        colorscheme = "base16-da-one-black";
        transparentBackground = true;
      };
    };
  };
}
