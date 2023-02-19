
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.acpi;
in

{
  options.modules.shell.acpi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ acpi ];
  };
}
