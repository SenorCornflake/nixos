{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.eww;
  layout = config.modules.desktop.programs.eww.layouts.trench;
in

{
  options.modules.desktop.programs.eww.layouts.trench = {
    background = mkOpt (types.str) "000000";
    foreground = mkOpt (types.str) "ffffff";
  };

  config = mkIf (cfg.layout == "trench") {
    fonts.fonts = with pkgs; [ material-design-icons ];
    
    modules.desktop.programs.eww.yuck = ''
      (defpoll hour :interval "1s" "date +%H")
      (defpoll min :interval "1s" "date +%M")
      (defpoll sec :interval "1s" "date +%S")
      (defpoll day_word :interval "10m" "date +%a | tr [:upper:] [:lower:]")
      (defpoll day :interval "10m" "date +%d")
      (defpoll month :interval "1h"  "date +%m")
      (defpoll year :interval "1h"  "date +%y")
      (defpoll temp :interval "5s"
        "temperature")
      (defpoll network_icon :interval "10s"
        "network custom '{\"wifi\": \"󰖩\", \"ethernet\": \"󰈀\", \"disconnected\": \"󰤮\"}'")
      (defpoll network :interval "10s"
        "network")
      (defpoll battery_percentage :interval "10s"
        "acpi -b | grep -o '[0-9]*%'")
      (defpoll battery_info :interval "10s"
        "acpi -b")
      (deflisten brightness :initial ""
        "brightness")
      (deflisten volume :initial ""
        "volume")
      (deflisten workspaces :initial ""
        "watch-hyprland-workspaces 0 '(label :class \"active-workspace\" :text \"<NAME>\")' '(label :class \"inactive-workspace\" :text \"<NAME>\")'")

      (defwidget workspaces []
        (literal
          :content
            "(box
              :class \"widget workspaces\"
              :orientation \"v\"
              ''${workspaces}
              )"))
      (defwidget topstuff []
        (box
          :class "topstuff"
          :orientation "v"
          :valign "start"
          :space-evenly false
          (workspaces)))
      (defwidget bottomstuff []
        (box
          :class "bottomstuff"
          :orientation "v"
          :valign "end"
          :space-evenly false
          (metric-icon
            :icon "󰔏"
            "''${temp}")
          (brightness)
          (volume)
          (network)
          (battery)
          (date)
          (time)))
      (defwidget metric-icon [icon ?tooltip ?font-size]
        (box
          :class "widget"
          :orientation "v"
          (label
            :class "metric-icon"
            :text icon
            :style {font-size == "" ? "" : "font-size: ''${font-size}rem;"}
            :tooltip tooltip)
          (children)))
      (defwidget network []
        (box
          :orientation "v"
          :class "widget"
          :tooltip network
          (label
            :class "metric-icon"
            :xalign 0.3
            :text network_icon)))
      (defwidget battery []
        (box
          :orientation "v"
          :class "widget"
          :tooltip battery_info
          (label
            :class "metric-icon"
            :text "󱊣")
          (label
            :class "metric-text"
            :text battery_percentage)))
      (defwidget brightness []
        (box
          :orientation "v"
          :class "widget"
          (label
            :class "metric-icon"
            :text "󰃠"
            :xalign 0.3)
          (label
            :class "metric-text"
            :text brightness)))
      (defwidget volume []
        (box
          :orientation "v"
          :class "widget"
          (label
            :class "metric-icon"
            :xalign 0.4
            :text {volume == "muted" ? "󰖁" : "󰕾"})
          (label
            :class "metric-text"
            :visible {volume == "muted" ? false : true}
            :text volume)))
      (defwidget date []
        (box
          :class "widget"
          :orientation "v"
          day_word
          day
          month
          year))
      (defwidget time []
        (box
          :class "widget"
          :orientation "v"
          hour
          min
          sec))
      (defwidget container []
        (centerbox
          :class "container"
          :orientation "v"
          (topstuff)
          (box)
          (bottomstuff)))
      (defwindow main
        :monitor 0
        :geometry (geometry
          :x "0"
          :y "0"
          :width "45px"
          :height "100%"
          :anchor "left center")
        :stacking "fg"
        :exclusive true
       (container))
    '';
    modules.desktop.programs.eww.scss = ''
      * {
        all: unset;
        font-family: Iosevka Nerd Font;
        font-size: 12px;
        color: #${layout.foreground};
      }
      tooltip {
        background: #000000;
        padding: 2rem;
        border-radius: 10px;
      }
      .metric-icon {
        font-size: 1.5rem;
      }
      .container {
        background-color: rgba(${hexToRGBString "," layout.background}, 0.9);
        border-right: solid 2px rgba(${hexToRGBString "," layout.background}, 0.4);
        padding-top: 5px;
        padding-bottom: 5px;
      }
      .widget {
        background-color: rgba(${hexToRGBString "," layout.background}, 0.7);
        border: solid 2px rgba(${hexToRGBString "," layout.foreground}, 0.1);
        border-radius: 10px;
        margin-left: 5px;
        margin-right: 5px;
        padding: 5px;
      }
      .bottomstuff .widget {
        margin-top: 5px;
      }
      .topstuff .widget {
        margin-bottom: 5px;
      }
      .workspaces .active-workspace, .workspaces .inactive-workspace {
        padding: 0px 5px;
        min-width: 1rem;
      }

      .workspaces .active-workspace {
        background-color: #${layout.foreground};
        color: #${layout.background};
        border: solid 2px rgba(${hexToRGBString "," layout.background}, 0.4);
        border-radius: 10px;
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
