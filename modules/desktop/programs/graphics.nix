{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.graphics;
in

{
  options.modules.desktop.programs.graphics = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      #blender
      krita
      (inkscape-with-extensions.override {
        inkscapeExtensions = (with inkscape-extensions; [
          #inkcut
        ]);
      })
    ];
  };
}
