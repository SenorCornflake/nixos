{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.theme;

  colors = {
    background = "111111";
    foreground = "dddddd";
    alt-background = "222222";
    accent = "11dddd";
  };

  hex = color: "#" + color;
in

mkIf (cfg.colorscheme == "default") {
  home-manager.users."${config.userName}" = {
    programs.mako = {
      backgroundColor = hex colors.background;
      borderColor = hex colors.accent;
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
        active_border = "rgba(${colors.foreground}ff)";
        inactive_border = "rgba(${colors.background}ff)";
        shadow_color = "rgba(000000ee)";
      };

      programs = {
        tofi = {
          background-color = hex colors.background;
          text-color = hex colors.foreground;
          selection-color = hex colors.accent;
        };
        eww.layouts = {
          default = {
            background = hex colors.background;
            foreground = hex colors.foreground;
            border = hex colors.alt-background;
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
            accent = hex colors.accent;
            border = hex colors.alt-background;
          };
        };
      };

      terminals = {
        kitty.colorscheme = (builtins.readFile (config.configDir + "/kitty/selenized-black.conf"));
      };
    };

    shell = {
      neovim = {
        colorscheme = "enfocado";
      };
    };
  };
}
