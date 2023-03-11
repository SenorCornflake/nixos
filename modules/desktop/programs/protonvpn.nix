{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.protonvpn;
in

{
  options.modules.desktop.programs.protonvpn = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ protonvpn-gui ];
  };
}
