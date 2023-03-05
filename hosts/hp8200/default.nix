{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  modules = {
    theme = {
      colorscheme = "default";
    };

    desktop = {
      hyprland.enable = true;
      gtk.enable = true;
      qt.enable = true;

      browsers = {
        firefox.enable = true;
      };

      editors = {
        vscode.enable = true;
      };

      terminals = {
        kitty.enable = true;
      };

      programs = {
        graphics.enable = true;
        media.enable = true;
        office.enable = true;
        qbittorrent.enable = true;
        tofi.enable = true;
        ark.enable = true;
        thunar.enable = true;
        mako.enable = true;
        wlogout.enable = true;
        pavucontrol.enable = true;
        blueberry.enable = true;
        okular.enable = true;
        zeal.enable = true;
        whatsapp.enable = true;
      };

      games = {
        enableGameSupport = true;
        mindustry.enable = true;
        dwarf-fortress.enable = true;
        openra.enable = true;
      };
    };

    servers = {
      apache.enable = true;
    };

    shell = {
      lf.enable = true;
      zsh.enable = true;
      exa.enable = true;
      neovim.enable = true;
      git.enable = true;
      bling.enable = true;
      monitoring-tools.enable = true;
      ytfzf.enable = true;
      acpi.enable = true;
      commander.enable = true;
      typing-practice.enable = true;
    };

    boot = {
      systemd-bootloader.enable = true;
    };

    hardware = {
      audio.enable = true;
      networking.enable = true;
      bluetooth.enable = true;
      printing.enable = true;
    };
  };

  system.stateVersion = "22.11";
  home-manager.users."${config.userName}".home.stateVersion = "22.11";
}
