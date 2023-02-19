{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.hardware.printing;
in

{
  options.modules.hardware.printing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplipWithPlugin
      samsung-unified-linux-driver
    ];
    environment.systemPackages = with pkgs; [
      hplipWithPlugin
    ];
    services.avahi.enable = true;
    # for a WiFi printer
    services.avahi.openFirewall = true;
    # for an USB printer
    #services.ipp-usb.enable = true; # Only works for nixos unstable as of right now
  };
}
