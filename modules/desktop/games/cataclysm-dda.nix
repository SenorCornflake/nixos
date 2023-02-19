{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.games.cataclysm-dda;
in

{
  options.modules.desktop.games.cataclysm-dda = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cataclysm-dda
    ];
  };
}
