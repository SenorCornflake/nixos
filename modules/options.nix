{ config, pkgs, lib, ... }:

let 
  inherit (lib) optional types;
  inherit (lib.my) mkBoolOpt mkOpt;
  cfg = config;

  userName = "a";
  homeDir = "/home/${userName}";
in
{
  options = {
    userName = mkOpt types.str userName;
    configDir = mkOpt types.path ../config;
    dotsDir = mkOpt types.path ../nixos;

    userHome = mkOpt types.path homeDir;
    dataHome = mkOpt types.path (homeDir + "/.local/share");
    configHome = mkOpt types.path (homeDir + "/.config");
    cacheHome = mkOpt types.path (homeDir + "/.cache");
    modules.userPackages = mkOpt (types.listOf types.attrs) [];
  };

  config = {
    users.users."${cfg.userName}" = {
      name = cfg.userName;
      initialPassword = "a";
      isNormalUser = true;
      createHome = true;
      home = "/home/${cfg.userName}";
      extraGroups = [ "wheel" "input" ];
    };

    environment.systemPackages = with pkgs; [ jq ];

    # TODO: Enable some of these only if their respective applications are installed
    home-manager.users."${config.userName}" = {
      home = {
        packages = cfg.modules.userPackages;
        sessionVariables = {
          MANPAGER = "nvim +Man!";
          MANWIDTH = 999;
          EDITOR = "nvim";
          VISUAL = "nvim";
          TERMINAL = "kitty";
          BROWSER = "firefox";
          VIDEO = "mpv";

          DOT_ROOT = config.dotsDir;
          #WALL_ROOT = config.wallpaperDir;
          PATH = "~/.local/bin:$PATH";
          SSH_ASKPASS = "";

          BAT_THEME="base16";

          # Highlight man pages in less (keep this there even though i use neovim for man pages)
          LESS_TERMCAP_mb = "$(tput bold; tput setaf 2)";
          # Start bold
          LESS_TERMCAP_md = "$(tput bold; tput setaf 2)"; # green
          # Start stand out
          LESS_TERMCAP_so = "$(tput bold; tput setaf 3)"; # yellow
          # End standout
          LESS_TERMCAP_se = "$(tput rmso; tput sgr0)";
          # Start underline
          LESS_TERMCAP_us = "$(tput smul; tput bold; tput setaf 1)"; # red
          # End Underline
          LESS_TERMCAP_ue = "$(tput sgr0)";
          # End bold, blinking, standout, underline
          LESS_TERMCAP_me = "$(tput sgr0)";
        };

        shellAliases = {
          v = "nvim";
          vs = "sudoedit";
          hc = "herbstclient";
          f = "lfimg";
          lf = "lfimg";
          t = "todo.sh -c";
          chmod_server = "sudo chmod -R 777 /srv/http && sudo chown -R wwwrun:wwwrun /srv/http && sudo chmod 755 /srv/http/phpmyadmin/config.inc.php";
          gp = "git push";
          gP = "git pull";
          gc = "git commit";
          ga = "git add";
          ls = (if config.modules.shell.exa.enable then "exa --git --icons" else "ls");
          weather = "curl -s \"wttr.in/$(echo \"$(curl -s https://ipinfo.io/)\" | jq -r '.city' | sed 's/ /+/g')\"";
        };
      };
    };
  };
}
