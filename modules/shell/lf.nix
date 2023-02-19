{ config, lib, pkgs, ... }:

# TODO: Create a derivation for lfimg
with lib;
with lib.my;

let 
  cfg = config.modules.shell.lf;
  deps = with pkgs; [
    trash-cli
    xdragon
    fzf
    file

    ueberzug
    ffmpegthumbnailer
    imagemagick
    poppler
    #epub-thumbnailer
    #wkhtmltopdf # Disable because of some qt error
    bat
    chafa
    unzip
    p7zip
    unrar
    catdoc
    python3Packages.docx2txt
    odt2txt
    gnumeric
    exiftool
    #iso-info
    transmission
    mcomix3
  ];
in
{
  options.modules.shell.lf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users."${config.userName}" = {
      home.packages = deps ++ [
        (pkgs.writeScriptBin "lfimg" (builtins.readFile "${config.configDir}/lf/lfrun"))
      ];

      xdg.configFile."lf/icons" = {
        recursive = false;
        source = "${config.configDir}/lf/icons";
        target = "lf/icons";
      };

      xdg.configFile."lf/preview" = {
        recursive = false;
        source = "${config.configDir}/lf/preview";
        target = "lf/preview";
        executable = true;
      };

      xdg.configFile."lf/cleaner" = {
        recursive = false;
        source = "${config.configDir}/lf/cleaner";
        target = "lf/cleaner";
        executable = true;
      };

      programs.lf = {
        enable = true;
        extraConfig = ''
          set previewer ~/.config/lf/preview
          set cleaner ~/.config/lf/cleaner
        '';
        settings = {
          ratios = "1:2:3";
          hidden = true;
          preview = true;
          drawbox = true;
          icons = true;
          ignorecase = true;
        };
        commands = {
          q = "quit";
          open = ''
            ''${{
                case $(file --mime-type "$f" -bL) in
                    text/*|application/json) $EDITOR "$f";;
                    *) xdg-open "$f" ;;
                esac
            }}
          '';
          chmod = ''
            ''${{
              printf "Mode Bits: "
              read ans

              for file in "$fx"
              do
                chmod $ans $file
              done

              lf -remote 'send reload'
            }}
          '';
          sudomkfile = ''
            ''${{
              printf "File Name: "
              read ans
              sudo $EDITOR $ans
            }}
          '';
          sudomkdir = ''
            ''${{
              printf "File Name: "
              read ans
              sudo mkdir $ans
            }}
          '';
          dragon = "%dragon -a -x \"$fx\"";

          trash = ''
            ''${{
              files=$(printf "$fx" | tr '\n' ';')
              while [ "$files" ]; do
                # extract the substring from start of string up to delimiter.
                # this is the first "element" of the string.
                file=''${files%%;*}

                trash-put "$(basename "$file")"
                # if there's only one element left, set `files` to an empty string.
                # this causes us to exit this `while` loop.
                # else, we delete the first "element" of the string from files, and move onto the next.
                if [ "$files" = "$file" ]; then
                  files='''
                else
                  files="''${files#*;}"
                fi
              done
            }}
          '';

          clear_trash = "%trash-empty";
          restore_trash = "\${{trash-restore}}";
          stripspace = "%stripspace \"$f\"";

          fzf_jump = ''
            ''${{
                res="$(find . -maxdepth 1 | fzf --header='Jump to location' | sed 's/\\/\\\\/g;s/"/\\"/g')"
                if [ -d "$res" ]; then
                    cmd="cd"
                else 
                    cmd="select"
                fi
                lf -remote "send $id $cmd \"$res\""
            }}
          '';

          fzf_jump_nodepth = ''
            ''${{
                res="$(find . | fzf --header='Jump to location' | sed 's/\\/\\\\/g;s/"/\\"/g')"
                if [ -d "$res" ]; then
                    cmd="cd"
                else 
                    cmd="select"
                fi
                lf -remote "send $id $cmd \"$res\""
            }}
          '';
        };
        keybindings = {
          "`h" = "cd ~";
          "`w" = "cd /srv/http";
          "`W" = "cd $WALL_ROOT";
          "`d" = "cd ~/Downloads";
          "`S" = "cd ~/Desktop";
          "`c" = "cd ~/.config";
          "`D" = "cd $DOT_ROOT";
          "<a-q>" = "quit";

          ee = "$$EDITOR \"$f\"";

          # "Trash Mappings
          x = "trash";
          tc = "clear_trash";
          tr = "restore_trash";

          # "Dragon Mapping";
          D = "dragon";

          ss = "stripspace";

          # Basic Functions";"
          "." = "set hidden!";
          X = "delete";
          p = "paste";
          d = "cut";
          y = "copy";
          "<enter>" = "open";
          A = "push %mkdir<space>";
          a = "push %touch<space>";
          "<c-A>" = "sudomkdir";
          "<c-a>" = "sudomkfile";
          ch = "chmod";
          r = "rename";
          H = "top";
          L = "bottom";
          c = "clear";
          u = "unselect";
          F = ":fzf_jump";
          "<c-f>" = ":fzf_jump_nodepth";
        };
      };
    };
  };
}
