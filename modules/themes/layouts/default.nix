{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.theme;
in

mkIf (cfg.layout == null || cfg.layout == "default") {
  modules = {
    desktop = {
      gtk = {
        font = "Noto Sans, 10";
      };

      programs = {
        mako.layout = "default";
        tofi.layout = "default";
        rofi.layout = "default";
        wlogout.layout = "default";
      };

      terminals = {
        kitty.layout = "default";
      };
    };
  };
}
