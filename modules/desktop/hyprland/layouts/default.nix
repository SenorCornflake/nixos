{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.hyprland;
  layout = config.modules.desktop.hyprland.layouts.default;
in

mkIf (cfg.layout == null || cfg.layout == "default") {
  modules.desktop.hyprland = {
    blur = "false";
    dim_inactive = "false";
    shadow = "true";
    shadow_range = "10";
    shadow_render_power = "2";
    shadow_scale = "1.0";
    shadow_offset = "[0, 0]";
    shadow_ignore_window = "true";
    gaps_in = "2.5";
    gaps_out = "5";
    border_size = "2";
    animations = ''
      enabled = true
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 7, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = border, 1, 10, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
    '';
  };
}

