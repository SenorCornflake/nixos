{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flavours
    yq
    jq
    pywal
    schemer2
    colorz
    python3Packages.colorthief
    haishoku
    auto-base16-theme
    feh
    fzf
    libnotify
    (writeShellScriptBin "apply_theme" ''
      flavours build $XDG_DATA_HOME/base16.yaml $XDG_DATA_HOME/flavours/base16/templates/kitty/templates/default.mustache > $XDG_DATA_HOME/kitty.conf
      flavours build $XDG_DATA_HOME/base16.yaml $XDG_DATA_HOME/flavours/base16/templates/wezterm/templates/default.mustache > $XDG_DATA_HOME/wezterm/wezterm.conf
      flavours build $XDG_DATA_HOME/base16.yaml $XDG_DATA_HOME/flavours/base16/templates/xresources/templates/default.mustache > $XDG_DATA_HOME/Xresources

      :r
      change_wallpaper update
      echo -n "reload" > $XDG_DATA_HOME/neovim_reload
      # To reload nix-wallpaper
      hyprctl reload
    '')
    (writeShellScriptBin "generate_base16_theme" ''
      filterer=$1
      wallpaper=""

      if [[ $filterer == "tofi" ]]; then
        wallpaper=$(ls $HOME/wallpapers | tofi)
      elif [[ $filterer == "rofi" ]]; then
        wallpaper=$(ls $HOME/wallpapers | rofi -dmenu)
      elif [[ $filterer == "fzf" ]]; then
        wallpaper=$(ls $HOME/wallpapers | sed "s/ /\n/g" | fzf)
      fi

      if [[ $wallpaper == "" ]]; then
        exit
      fi

      if [[ $2 == "flavours" ]]; then
        if [[ $wallpaper != "" ]]; then
          notify-send "Flavours" "Generating $3 base16 theme using $wallpaper"
          flavours generate $3 $HOME/wallpapers/$wallpaper --stdout > $XDG_DATA_HOME/base16.yaml
          flavours generate $3 $HOME/wallpapers/$wallpaper --stdout | yq > $XDG_DATA_HOME/base16.json
        fi
      elif [[ $2 == "schemer2" ]]; then
        template="scheme: \"Generated\"
      author: \"Schemer2\"

      base00: \"{}\"
      base01: \"{}\"
      base02: \"{}\"
      base03: \"{}\"
      base04: \"{}\"
      base05: \"{}\"
      base06: \"{}\"
      base07: \"{}\"

      base08: \"{}\"
      base09: \"{}\"
      base0A: \"{}\"
      base0B: \"{}\"
      base0C: \"{}\"
      base0D: \"{}\"
      base0E: \"{}\"
      base0F: \"{}\"
        "

        echo "$template" > $XDG_DATA_HOME/auto-base16-template.el

        notify-send "Schemer2" "Generating base16 theme using $wallpaper"
        # Generate the colors with schemer2
        schemer2 -format img::colors -in "$HOME/wallpapers/$wallpaper" -out "$XDG_DATA_HOME/colors.txt"
        # Create the base16 theme with this
        auto-base16-theme --inputColorPaletteFile $XDG_DATA_HOME/colors.txt $XDG_DATA_HOME/auto-base16-template.el $XDG_DATA_HOME/base16.yaml
        # Create JSON version of base16 theme
        echo "$(cat $XDG_DATA_HOME/base16.yaml)" | yq > $XDG_DATA_HOME/base16.json
      elif [[ $2 == "pywal" ]]; then
        if [[ $3 == "light" ]]; then
          notify-send "Pywal" "Generating light base16 theme using wal with $4 backend on $wallpaper"
          wal -l -n -e -s -t --backend $4 -i $HOME/wallpapers/$wallpaper
        else
          notify-send "Pywal" "Generating dark base16 theme using wal with $4 backend on $wallpaper"
          wal -n -e -s -t --backend $4 -i $HOME/wallpapers/$wallpaper
        fi

        color0=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color0" | sed "s/#//g")
        color1=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color1" | sed "s/#//g")
        color2=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color2" | sed "s/#//g")
        color3=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color3" | sed "s/#//g")
        color4=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color4" | sed "s/#//g")
        color5=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color5" | sed "s/#//g")
        color6=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color6" | sed "s/#//g")
        color7=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color7" | sed "s/#//g")
        color8=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color8" | sed "s/#//g")
        color9=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color9" | sed "s/#//g")
        color10=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color10" | sed "s/#//g")
        color11=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color11" | sed "s/#//g")
        color12=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color12" | sed "s/#//g")
        color13=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color13" | sed "s/#//g")
        color14=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color14" | sed "s/#//g")
        color15=$(cat $XDG_CACHE_HOME/wal/colors.json | jq -r ".colors.color15" | sed "s/#//g")

        base16="
      scheme: \"Generated\"
      author: \"Pywal\"

      base00: \"$color0\"
      base01: \"$color10\"
      base02: \"$color11\"
      base03: \"$color8\"
      base04: \"$color12\"
      base05: \"$color7\"
      base06: \"$color13\"
      base07: \"$color15\"

      base08: \"$color1\"
      base09: \"$color9\"
      base0A: \"$color3\"
      base0B: \"$color2\"
      base0C: \"$color6\"
      base0D: \"$color4\"
      base0E: \"$color5\"
      base0F: \"$color14\"
        "

        echo "$base16" > $XDG_DATA_HOME/base16.yaml
        echo "$base16" | yq > $XDG_DATA_HOME/base16.json
      fi

      echo -n "$wallpaper" > $XDG_DATA_HOME/imperative_wallpaper


      apply_theme
    '')
  ];
}
