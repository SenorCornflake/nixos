{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.theme;
in

mkIf (cfg.layout == "trench") {
  modules = {
    desktop = {
      gtk = {
        font = "Noto Sans, 10";
      };

      hyprland.layout = "trench";

      programs = {
        mako.layout = "trench";
        waybar.layout = "default";
        tofi.layout = "default";
        eww.layout = "trench";
        rofi.layout = "trench";
        wlogout.layout = "default";
      };

      terminals = {
        kitty.layout = "trench";
      };
    };
  };
}
