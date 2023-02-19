{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.hyprland;
  layout = config.modules.desktop.hyprland.layouts.default;
in

mkIf (cfg.layout == "trench") {
  modules.desktop.hyprland = {
    blur = "true";
    blur_size = "8";
    blur_passes = "3";
    blur_xray = "true";
    dim_inactive = "false";
    shadow = "true";
    shadow_range = "10";
    shadow_render_power = "2";
    shadow_scale = "1.0";
    shadow_offset = "[0, 0]";
    shadow_ignore_window = "true";
    gaps_in = "5";
    gaps_out = "10";
    rounding = "5";
    border_size = "2";
    dwindle.no_gaps_when_only = "true";
    animations = ''
      enabled = true

      bezier = mine, 1, 0, 0.58, 1
      bezier = speed, 0.01, 0.91, 0.34, 0.99 
      bezier = easeinout,  0.42, 0, 0.58, 1
      bezier = fast, 0.05, 0.9, 0.1, 1.05

      animation = windows, 1, 2, fast
      animation = fade, 1, 2, easeinout
      animation = workspaces, 1, 3, speed, slidevert
    '';
  };
}

