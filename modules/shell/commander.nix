
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.commander;
in

{
  options.modules.shell.commander = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      commander
      python3
    ];

    home-manager.users."${config.userName}" = {
      xdg.configFile."commander" = {
        target = "commander/commands.json";
        recursive = false;
        source = config.configDir + "/commander/commands.json";
      };
    };
  };
}
