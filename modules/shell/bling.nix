{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.bling;
in

{
  options.modules.shell.bling = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      macchina
      neofetch
      bfetch
      asciiquarium
      cmatrix
      cbonsai
    ];
  };
}
