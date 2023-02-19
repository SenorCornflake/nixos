{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.programs.okular;
in

{
  options.modules.desktop.programs.okular = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libsForQt5.okular
    ];
  };
}
