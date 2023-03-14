{ config, pkgs, lib, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.hardware.networking;
in

{
  options.modules.hardware.networking = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.firewall = {
      enable = false;
    };

    users.users.${config.userName}.extraGroups = [ "networkmanager" ];
  };
}
