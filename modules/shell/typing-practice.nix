{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.typing-practice;
in

{
  options.modules.shell.typing-practice = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gtypist
      ttyper
    ];
  };
}
