{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.browsers.firefox;
in
{
  options.modules.desktop.browsers.firefox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      programs.firefox = {
        enable = true;
        profiles = {
          myprofile = {
            settings = {
              "general.autoScroll" = true;
              "general.smoothScroll" = true;
            };
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              bitwarden
              ublock-origin
              h264ify
            ];
          };
        };
      };
    };
  };
}
