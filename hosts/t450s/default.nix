{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  modules = {
    theme = {
      colorscheme = "default";
      layout = "default";
    };

    desktop = {
      kde.enable = true;
      gtk.enable = true;
      qt.enable = true;

      browsers = {
        firefox.enable = true;
      };

      editors = {
        vscode.enable = false;
      };

      terminals = {
        kitty.enable = true;
      };

      programs = {
        graphics.enable = true;
        media.enable = true;
        office.enable = true;
        gparted.enable = true;
        qbittorrent.enable = true;
        ark.enable = true;
        pavucontrol.enable = true;
        blueberry.enable = true;
        okular.enable = true;
        zeal.enable = true;
        whatsapp.enable = true;
        virtualbox.enable = true;
        protonvpn.enable = true;
      };

      games = {
        enableGameSupport = true;
        mindustry.enable = true;
        dwarf-fortress.enable = false;
        cataclysm-dda.enable = true;
        openttd.enable = true;
        wesnoth.enable = false;
        xonotic.enable = true;
        zeroad.enable = false;
        endless-sky.enable = true;
        freeciv.enable = true;
        shattered-pixel-dungeon.enable = true;
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
