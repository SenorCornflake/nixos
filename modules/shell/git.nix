{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let 
  cfg = config.modules.shell.git;
in

{
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      programs.git = {
        enable = true;
        userName = "Baker";
        userEmail = "cmdwannabe@gmail.com";
        extraConfig = {
          credential = {
            helper = "store";
          };
        };
      };
    };
  };
}

