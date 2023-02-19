{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.boot.systemd-bootloader;
in

{
  options.modules.boot.systemd-bootloader = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
  };
}