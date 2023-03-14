{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.veracrypt;
in

{
  options.modules.desktop.programs.veracrypt = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      veracrypt
    ];
  };
}
