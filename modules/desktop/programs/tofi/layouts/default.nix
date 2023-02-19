{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.desktop.programs.tofi;
in
mkIf (cfg.layout == null || cfg.layout == "default") {
  modules.desktop.programs.tofi.extraConfig = ''
    font = "Iosevka Nerd Font"
    font-size = 10
    hint-font = true
    prompt-text = "> "
    horizontal = true
    num-results = 0
    width = 100%
    height = 25
    outline-width = 0
    border-width = 0
    result-spacing = 15
    min-input-width = 120
    scale = true
    output = ""
    anchor = bottom
    history = true
    fuzzy-match = true
    padding-top = 2
    padding-right = 0
    padding-bottom = 0
    padding-left = 5
  '';
}
