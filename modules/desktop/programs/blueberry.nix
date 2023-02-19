{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.blueberry;
in

{
  options.modules.desktop.programs.blueberry = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blueberry
    ];
  };
}
