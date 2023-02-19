{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.games.shattered-pixel-dungeon;
in

{
  options.modules.desktop.games.shattered-pixel-dungeon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      shattered-pixel-dungeon
    ];
  };
}
