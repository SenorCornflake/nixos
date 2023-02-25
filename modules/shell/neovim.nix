{ inputs, config, lib, pkgs, pkgs-unstable, pkgs-stable, ... }:

with builtins;
with lib;
with lib.my;

let
  cfg = config.modules.shell.neovim;

  flake-plugins = (pkgs.lib.genAttrs
    [
      "dial-nvim"
      "neo-tree-nvim"
      "nvim-scrollbar"
      "yankassassin-vim"
      "nvim-base16"
      "vim-enfocado"
      "vim-moonfly-colors"
      "calvera-dark-nvim"
      "substrata-nvim"
      "monochrome-nvim"
      "zenbones-nvim"
      "alpha-nvim"
      "kanagawa-nvim"
      "vscode-nvim"
    ]
    (plugin-name: pkgs.vimUtils.buildVimPlugin {
      name = plugin-name;  
      dontBuild = true;
      src = inputs.${plugin-name};
    }));
in
{
  options.modules.shell.neovim = {
    enable = mkBoolOpt false;
    colorscheme = mkOpt types.str "default";
    transparentBackground = mkOpt types.bool false;
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs; [
      material-design-icons
    ];

    environment.systemPackages = with pkgs; [
      neovim
    ];

    home-manager.users."${config.userName}" = {
      xdg.configFile."lua" = {
        target = "nvim/lua";
        source = (config.configDir + "/nvim/lua");
        recursive = true;
      };

      xdg.configFile."main.lua" = {
        target = "nvim/main.lua";
        source = (config.configDir + "/nvim/main.lua");
        recursive = false;
      };

      xdg.dataFile."neovim_colorscheme.txt" = {
        target = "neovim_colorscheme.txt";
        text = cfg.colorscheme; 
        recursive = false;
      };

      xdg.dataFile."neovim_transparent_background.txt" = {
        target = "neovim_transparent_background.txt";
        text = (if cfg.transparentBackground then "true" else "false"); 
        recursive = false;
      };

      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        withRuby = true;
        withPython3 = true;
        withNodeJs = true;

        extraConfig = ''
          luafile ~/.config/nvim/main.lua
        '';

        extraPackages = with pkgs-unstable; [
          tree-sitter
          gcc
          bat
          ripgrep

          # Language servers
          rnix-lsp
          sumneko-lua-language-server
          rust-analyzer
          nodePackages.typescript-language-server
          nodePackages.vscode-css-languageserver-bin
          nodePackages.vscode-html-languageserver-bin
          nodePackages.vscode-json-languageserver-bin
          nodePackages.pyright
          nodePackages.intelephense
          yq
          coreutils
          xclip
          wl-clipboard
        ];

        extraPython3Packages = (p: with p; [
          pynvim
          typer
          requests
        ]);

        plugins = with pkgs-unstable.vimPlugins; [
          # Deps
          lush-nvim # zenbones dependancy
          nui-nvim # neo tree dependancy
          nvim-web-devicons # dependancy for many plugins
          plenary-nvim # dependancy for many plugins

          # Plugs
          nvim-treesitter-refactor
          (nvim-treesitter.withPlugins (p: [
            p.php
            p.javascript
            p.python
            p.rust
            p.json
            p.go
            p.html
            p.scss
            p.css
            p.typescript
            p.vim
            p.lua
            p.nix
            p.yaml
            p.toml
            #p.sql
            p.ini
            p.latex
            p.c
            p.cpp
            p.c_sharp
            p.java
            p.kotlin
          ]))
          nvim-treesitter-refactor
          nvim-treesitter-textobjects
          nvim-ts-autotag
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          emmet-vim
          feline-nvim
          gitsigns-nvim
          hop-nvim
          kommentary
          lspkind-nvim
          luasnip
          friendly-snippets
          nvim-autopairs
          nvim-cmp
          nvim-lspconfig
          project-nvim
          surround-nvim
          targets-vim
          telescope-nvim
          vim-floaterm
          lf-vim
          vim-fugitive
          vim-hexokinase
          vim-startuptime
          which-key-nvim
          winshift-nvim
          fwatch-nvim
          nvim-navic

          catppuccin-nvim
          gruvbox-material
          material-nvim
          nord-nvim
          tokyonight-nvim
        ] ++ (pkgs.lib.mapAttrsToList (_: plugin: plugin) flake-plugins);
      };
    };
  };
}
