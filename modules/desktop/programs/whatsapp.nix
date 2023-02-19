{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.whatsapp;
in

{
  options.modules.desktop.programs.whatsapp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      whatsapp-for-linux
    ];
  };
}
