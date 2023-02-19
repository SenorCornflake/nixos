{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.games;
in
{
  options.modules.desktop.games = {
    enableGameSupport = mkBoolOpt false;
  };

  config = mkIf cfg.enableGameSupport {
    environment.systemPackages = with pkgs; [
      lutris
      winetricks
      wineWowPackages.stagingFull
      mangohud
      gamemode
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };


    home-manager.users."${config.userName}" = {
      xdg.configFile."MangoHud/MangoHud.conf" = {
        source = "${config.configDir}/mangohud/mangohud.conf";
      };
    };
  };
}
