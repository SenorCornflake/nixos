
{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.kde;
in

{
  options.modules.desktop.kde = {
      enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      displayManager.sddm.enable = true;
    };

    environment.systemPackages = with pkgs; [
      libsForQt5.bismuth
      libsForQt5.kdeconnect-kde
      libsForQt5.kdenetwork-filesharing
      libsForQt5.qt5.qtbase
      qt6.qtbase
      aha
      pciutils
      glxinfo
      vulkan-tools
      xorg.xdpyinfo
      unixtools.quota
    ];

    services.fwupd.enable = true;
  };
}
