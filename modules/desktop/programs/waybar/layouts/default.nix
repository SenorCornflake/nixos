{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.waybar;
  layout = config.modules.desktop.programs.waybar.layouts.default;
in

{
  options.modules.desktop.programs.waybar.layouts.default = {
    background = mkOpt (types.str) "#000000";
    border = mkOpt (types.str) "#222222";
    foreground = mkOpt (types.str) "#ffffff";
  };

  config = mkIf (cfg.layout == null || cfg.layout == "default") {
    home-manager.users."${config.userName}" = {
      programs.waybar = {
          style =  ''
            * {
              border: none;
              border-radius: 0;
              font-family: Iosevka Nerd Font;
              font-size: 12px;
              color: ${layout.foreground};
            }

            tooltip label {
              color: white;
            }

            window#waybar {
              background: transparent;
            }

            #window {
              padding: 0 10px;
              padding-top: 2px;
              border: solid 2px ${layout.border};
              background: ${layout.background};
            }

            #clock, #battery, #wireplumber, #cpu, #memory, #network, #backlight, #temperature, #custom-hyprland-workspaces, #disk {
              padding: 0 10px;
              padding-top: 2px;
              margin-left: 5px;
              border: solid 2px ${layout.border};
              background: ${layout.background};
            } 

            #tray {
              padding: 0 10px;
              padding-top: 2px;
              margin-left: 5px;
              border: solid 2px ${layout.border};
              background: ${layout.background};
            }
        '';
        settings = {
          bar = {
            layer = "top";
            position = "top";
            height = 25;
            margin-top = 5;
            margin-right = 5;
            margin-left = 5;
            output = [
              "eDP-1"
            ];
            modules-left = [ "hyprland/window" "custom/hyprland-workspaces" ];
            modules-right = [ "network" "disk" "memory" "cpu" "temperature" "backlight" "wireplumber" "battery" "clock" "tray" ];

            "disk" = {
              format = "DISK {free}";
              interval = 60;
              path = "/";
            };

            "custom/hyprland-workspaces" = {
              exec = "${config.modules.scripts.hyprland-workspaces}/bin/hyprland-workspaces";
              format = "{}";
              interval = "once";
              signal = 8;
            };

            clock = {
              interval = 60;
              format = "{:%a, %d %b %Y %H:%M}";
            };

            battery = {
              format = "BAT {capacity}%";
              interval = 20;
            };

            wireplumber = {
              format = "VOL {volume}%";
              format-muted = "VOL X";
            };

            cpu = {
              format = "CPU {usage}%";
              interval = 5;
            };

            memory = {
              format = "MEM {used} GiB";
              interval = 5;
            };

            network = {
              format-disconnected = "";
              format-wifi = "NET {essid} {bandwidthTotalBits}";
              format-ethernet = "NET {ifname} {bandwidthTotalBits}";
            };

            tray = {
              icon-size = 14;
            };

            backlight = {
              format = "BRIGHT {percent}%";
            };

            temperature = {
              format = "TEMP {temperatureC}°C";
            };
          };
        };
      };
    };
  };
}
