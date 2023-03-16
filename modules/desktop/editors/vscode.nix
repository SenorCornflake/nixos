{ config, pkgs, pkgs-unstable, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.editors.vscode;
in

{
  options.modules.desktop.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}".programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      userSettings = {
          "vim.insertModeKeyBindings" = [
              {
                  "before" = ["k" "j"];
                  "after" = ["<Esc>"];
              }
          ];
          "editor.fontFamily" = "'Iosevka Nerd Font'";
          "editor.fontSize" = 14;
          "workbench.colorTheme" = "Enfocado Dark Nature";
        };
      extensions = with pkgs; [
        vscode-extensions.bbenoist.nix
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.vscodevim.vim
      ];
    };
  };
}
