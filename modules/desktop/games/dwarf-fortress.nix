{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.games.dwarf-fortress;
in

{
  options.modules.desktop.games.dwarf-fortress = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableIntro = false;
        enableTruetype = true;
        enableFPS = true;
        enableSound = false;
        enableSoundSense = true;
        enableStoneSense = false;
        enableDwarfTherapist = false;
        theme = dwarf-fortress-packages.themes.phoebus;
      })
    ];
  };
}
