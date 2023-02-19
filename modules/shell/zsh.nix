
{ inputs, config, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;

let 
  cfg = config.modules.shell.zsh;
in
{

  options.modules.shell.zsh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.users."${config.userName}" = {
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [ any-nix-shell ];

    home-manager.users."${config.userName}" = {
      programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";

        history = {
          save = 1000;
          size = 1000;
          path = ".local/share/zsh/history";
        };

        completionInit = ''
          autoload -U compinit && compinit -d ~/.config/zsh/zcompdump
        '';

        plugins = [
          {
            name = "zsh-fast-syntax-highlighting";
            file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
            src = "${pkgs.zsh-fast-syntax-highlighting}";
          }
          {
            name = "zsh-autosuggestions";
            file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
            src = "${pkgs.zsh-autosuggestions}";
          }
          {
            name = "zsh-history-substring-search";
            file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
            src = "${pkgs.zsh-history-substring-search}";
          }
          {
            name = "zsh-vi-mode";
            src = "${pkgs.zsh-vi-mode}";
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
        ];

        # .zshrc
        initExtra = ''
          ZVM_VI_INSERT_ESCAPE_BINDKEY=kj

          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
          bindkey "\e[3~" delete-char

          autoload edit-command-line; zle -N edit-command-line
          bindkey '^v' edit-command-line

          zstyle ':completion:*' menu select
          zstyle ':completion:*' matcher-list ${"''"} 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # match all case
          _comp_options+=(globdots) # complete hidden files
          bindkey '^[[Z' reverse-menu-complete

          any-nix-shell zsh --info-right | source /dev/stdin

          PROMPT=' %F{blue}%~%f  '
        '';

        # .zshenv
        envExtra = '''';
      };
    };
  };
}
