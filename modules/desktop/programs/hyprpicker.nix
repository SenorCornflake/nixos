{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.hyprpicker;
in

{
  options.modules.desktop.programs.hyprpicker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.hyprpicker.packages.x86_64-linux.default
    ];
  };
}
