{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.wlogout;
  layout = config.modules.desktop.programs.wlogout.layouts.default;
in

{
  options.modules.desktop.programs.wlogout.layouts.default = {
    background = mkOpt types.str "#000000";
    foreground = mkOpt types.str "#ffffff";
    border = mkOpt types.str "#aaaaaa";
    accent = mkOpt types.str "#00ff00";
  };

  config = mkIf (cfg.layout == null || cfg.layout == "default") {
    modules.desktop.programs.wlogout.styles = ''
      * {
          background-image: none;
          padding-top: 0;
          padding-left: 0;
          padding-right: 0;
          padding-bottom: 0;
          min-height: 0;
      }
      window {
          background-color: ${layout.background};
      }
      button {
          color: ${layout.foreground};
          background-color: ${layout.background};
          border-style: solid;
          border-width: 2px;
          border-radius: 0px;
          border-color: ${layout.border};
          margin: 1rem;
          font-size: 48px;
          font-family: Iosevka Nerd Font;
          outline-style: none;
      }

      button:focus, button:active, button:hover {
          background-color: ${layout.accent};
          outline-style: none;
          color: ${layout.background}
      }
    '';
  };
}

