{ config, lib, ... }: 

with lib;
with lib.my;

let
  cfg = config.modules.boot.grub;
in
{
  options.modules.boot.grub = {
    enable = mkBoolOpt false;
    useOSProber = mkBoolOpt true;
    devices = mkOpt (types.listOf types.str) [ "/dev/sda" ];
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub = {
          enable = true;
          devices = cfg.devices;
          useOSProber = cfg.useOSProber;
          version = 2;
        };
      };
    };
  };
}
