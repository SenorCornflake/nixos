{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.eww;
  layout = config.modules.desktop.programs.eww.layouts.default;

  net_down = ''EWW_NET[interface].NET_DOWN'';
  net_downspeed = ''''${${net_down} > 1000000 ? "''${round(${net_down} / 1000000, 1)}mb/s" : ${net_down} > 1000 ? "''${round(${net_down} / 1000, 1)}kb/s" : "''${${net_down}}b/s" }'';

  net_up = ''EWW_NET[interface].NET_UP'';
  net_upspeed = ''''${${net_up} > 1000000 ? "''${round(${net_up} / 1000000, 1)}mb/s" : ${net_up} > 1000 ? "''${round(${net_up} / 1000, 1)}kb/s" : "''${${net_up}}b/s" }'';
in

{
  options.modules.desktop.programs.eww.layouts.default = {
    background = mkOpt (types.str) "#000000";
    border = mkOpt (types.str) "#222222";
    foreground = mkOpt (types.str) "#ffffff";
  };

  config = mkIf (cfg.layout == null || cfg.layout == "default") {
    modules.desktop.programs.eww.yuck = ''
      (defpoll time :interval "10s"
        "date '+%a, %b %d %Y %H:%M'")
      (defpoll battery :interval "10s"
        "acpi -b | grep -o '[0-9]*%'")
      (defpoll temp :interval "5s"
        "temperature")
      (deflisten volume :initial "0"
        "volume")
      (deflisten brightness :initial "0"
        "brightness")
      (deflisten title :initial ""
        "hyprland-title")
      (deflisten workspaces :initial ""
        "watch-hyprland-workspaces 0 \" <NAME> \" \" <NAME> \"")
      (defpoll interface :interval "10s"
        "network interface")
      (defpoll net_name :interval "10s"
        "network")
      (defwidget time []
        (box
          :class "time"
          time))
      (defwidget battery []
        (box
          :class "battery"
          "BAT ''${battery}"))
      (defwidget volume []
        (box
          :class "volume"
          "VOL ''${volume == "muted" ? "X" : "''${volume}%"}"))
      (defwidget brightness []
        (box
          :class "brightness"
          "BRIGHT ''${brightness}"))
      (defwidget temp []
        (box
          :class "temp"
          "TEMP ''${temp}°C"))
      (defwidget cpu []
        (box
          :class "cpu"
          "CPU ''${round(EWW_CPU["avg"], 0)}%"))
      (defwidget ram []
        (box
          :class "ram"
          "RAM ''${round(EWW_RAM["used_mem"] / 1000000000, 2)}GiB"))
      (defwidget disk []
        (box
          :class "disk"
          "DISK ''${round(EWW_DISK["/"].free / 1000000000, 1)}GiB"))
      (defwidget net []
        (box
          :class "net"
          "NET ''${net_name}"))
      (defwidget title []
        (box
          :class "title"
          (label
            :limit-width 30
            :show_truncated true
            :text "''${title == "" ? "-" : title}")))
      (defwidget workspaces []
        (box
          :class "workspaces"
          "''${workspaces}"))
      (defwidget rightside []
        (box
          :class "rightside"
          :orientation "h"
          :halign "end"
          :space-evenly false
          (net)
          (disk)
          (ram)
          (cpu)
          (temp)
          (brightness)
          (volume)
          (battery)
          (time)))
      (defwidget leftside []
        (box
          :class "leftside"
          :orientation "h"
          :space-evenly false
          (title)
          (workspaces)))
      (defwidget container []
        (centerbox
          :class "container"
          :orientation "h"
          (leftside)
          (box)
          (rightside)))
      (defwindow main
        :monitor 0
        :geometry (geometry
          :x "0"
          :y "0"
          :width "100%"
          :height "25px"
          :anchor "top center")
        :stacking "bottom"
        :exclusive true
       (container))
    '';
    modules.desktop.programs.eww.scss = ''
      * {
        all: unset;
        font-family: Iosevka Nerd Font;
        font-size: 12px;
        color: ${layout.foreground};
      }

      .container {
        background: transparent;
      }

      .time, .battery, .volume, .brightness, .temp, .cpu, .ram, .disk, .net, .title, .workspaces {
        border: solid 2px ${layout.border};
        background: ${layout.background};
        margin: 5px;
        padding: 5px;
      }
    '';
    home-manager.users."${config.userName}" = {
      xdg.dataFile."start-eww" = {
        target = "start-eww.sh";
        text = ''
          #!/usr/bin/env bash
          if [[ $(pgrep eww) ]]; then
            eww reload
          else
            eww open main
          fi
        '';
        executable = true;
      };
    };
  };
}
