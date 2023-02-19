{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.games.wesnoth;
in

{
  options.modules.desktop.games.wesnoth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wesnoth
    ];
  };
}
