{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.monitoring-tools;
in

{
  options.modules.shell.monitoring-tools = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      htop
      bottom
    ];
  };
}
