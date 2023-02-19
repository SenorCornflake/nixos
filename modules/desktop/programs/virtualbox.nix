{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.virtualbox;
in

{
  options.modules.desktop.programs.virtualbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.extraGroups.vboxusers.members = [ config.userName ];

    virtualisation.virtualbox = {
      host.enable = true;
      host.enableExtensionPack = true;
      guest.enable = true;
    };
  };
}
