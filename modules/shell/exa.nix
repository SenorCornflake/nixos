
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.exa;
in

{
  options.modules.shell.exa = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      programs.exa = {
        enable = true;
        enableAliases = false;
      };
    };
  };
}
