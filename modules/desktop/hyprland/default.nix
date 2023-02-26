{ inputs, config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.hyprland;
in

{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
    layout = mkOpt (types.nullOr types.str) null;
    active_border = mkOpt types.str "rgba(ffffffff)";
    inactive_border = mkOpt types.str "rgba(999999ff)";
    shadow_color = mkOpt types.str "rgba(000000ee)";
    inactive_shadow_color = mkOpt types.str "rgba(000000ee)";
    gaps_in = mkOpt types.str "10";
    gaps_out = mkOpt types.str "10";
    border_size = mkOpt types.str "2";
    animations = mkOpt types.str '''';
    rounding = mkOpt types.str "0";
    blur = mkOpt types.str "false";
    blur_size = mkOpt types.str "8";
    blur_passes = mkOpt types.str "1";
    blur_ignore_opacity = mkOpt types.str "false";
    blur_xray = mkOpt types.str "false";
    shadow = mkOpt types.str "false";
    shadow_range = mkOpt types.str "10";
    shadow_render_power = mkOpt types.str "2";
    shadow_scale = mkOpt types.str "1.0";
    shadow_offset = mkOpt types.str "[0, 0]";
    shadow_ignore_window = mkOpt types.str "true";
    dim_inactive = mkOpt types.str "false";
    dim_strength = mkOpt types.str "0.1";
    dwindle.no_gaps_when_only = mkOpt types.str "false";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      polkit_gnome
      swaybg
      swayidle
      xorg.xhost
      xorg.xset
      brightnessctl
      commander
      grim
      slurp
      (writeShellScriptBin "X" ''
        cd ~

        export _JAVA_AWT_WM_NONREPARENTING=1
        export XCURSOR_SIZE=${builtins.toString config.modules.desktop.gtk.cursorSize}

        exec Hyprland
      '')
      (writeShellScriptBin "idle_manager" ''
        PATH=${lib.makeBinPath (with pkgs; [ pkgs.swayidle pkgs.hyprland ])}
        swayidle -w \
          timeout 400 ' hyprctl dispatch dpms off' \
          resume ' hyprctl dispatch dpms on'
      '')
    ];


    home-manager.users."${config.userName}" = {
      imports = [ inputs.hyprland.homeManagerModules.default ];

      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          monitor=,preferred,auto,1

          # Enable repaet for capslock key for xwayland applications
          exec-once = xset r 66
          exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
          exec-once = restore_nightmode_state
          exec = pkill mako
          exec-once = xhost +local:
          exec-once = idle_manager
          exec = $XDG_DATA_HOME/start-eww.sh

          input {
              kb_layout = us
              kb_variant =
              kb_model =
              kb_options = keypad:pointerkeys,caps:backspace
              kb_rules =

              repeat_rate = 30
              repeat_delay = 250
bool
              follow_mouse = 0

              touchpad {
                  natural_scroll = true
                  disable_while_typing = true
                  scroll_factor = 1.0
                  tap-to-click = true
              }

              sensitivity = 0
          }

          general {
              gaps_in = ${cfg.gaps_in}
              gaps_out = ${cfg.gaps_out}
              border_size = ${cfg.border_size}
              col.active_border = ${cfg.active_border}
              col.inactive_border = ${cfg.inactive_border}
              layout = dwindle
          }

          decoration {
              rounding = ${cfg.rounding}
              blur = ${cfg.blur}
              blur_size = ${cfg.blur_size}
              blur_passes = ${cfg.blur_passes}
              blur_ignore_opacity = ${cfg.blur_ignore_opacity}
              blur_new_optimizations = true
              blur_xray = ${cfg.blur_xray}
              drop_shadow = ${cfg.shadow}
              shadow_range = ${cfg.shadow_range}
              shadow_render_power = ${cfg.shadow_render_power}
              shadow_ignore_window = ${cfg.shadow_ignore_window}
              shadow_offset = ${cfg.shadow_offset}
              col.shadow = ${cfg.shadow_color}
              shadow_scale = ${cfg.shadow_scale}
              dim_inactive = ${cfg.dim_inactive}
              dim_strength = ${cfg.dim_strength}
          }

          blurls=gtk-layer-shell
          blurls=rofi

          animations {
          ${cfg.animations}
          }

          dwindle {
              force_split = 2
              pseudotile = true
              preserve_split = true
              no_gaps_when_only = ${cfg.dwindle.no_gaps_when_only}
          }

          master {
              new_is_master = true
          }

          gestures {
              workspace_swipe = true
              workspace_swipe_distance = 100
              workspace_swipe_cancel_ratio = 0.2
          }

          misc {
              disable_autoreload = false
              disable_hyprland_logo = true
              enable_swallow = true
              disable_splash_rendering = true
          }

          windowrulev2 = float,class:^(Thunar)$,title:^(File Operation Progress)$
          windowrulev2 = float,class:^(Rofi)$

          bind = SUPER, RETURN, exec, kitty
          bind = SUPER, w, killactive,
          bind = SUPER_SHIFT, R, exec, hyprctl reload
          bind = SUPER, F, togglefloating,
          #bind = SUPER, A, exec, tofi-run | xargs hyprctl keyword exec
          bind = SUPER, A, exec, rofi -modi drun -show drun
          bind = SUPER, P, pseudo,
          bind = SUPER, S, togglesplit,

          bind = SUPER, H, movefocus, l
          bind = SUPER, L, movefocus, r
          bind = SUPER, K, movefocus, u
          bind = SUPER, J, movefocus, d

          bind = SUPER, 1, workspace, 1
          bind = SUPER, 2, workspace, 2
          bind = SUPER, 3, workspace, 3
          bind = SUPER, 4, workspace, 4
          bind = SUPER, 5, workspace, 5
          bind = SUPER, 6, workspace, 6
          bind = SUPER, 7, workspace, 7
          bind = SUPER, 8, workspace, 8
          bind = SUPER, 9, workspace, 9
          bind = SUPER, 0, workspace, 10

          bind = SUPER_SHIFT, 1, movetoworkspacesilent, 1
          bind = SUPER_SHIFT, 2, movetoworkspacesilent, 2
          bind = SUPER_SHIFT, 3, movetoworkspacesilent, 3
          bind = SUPER_SHIFT, 4, movetoworkspacesilent, 4
          bind = SUPER_SHIFT, 5, movetoworkspacesilent, 5
          bind = SUPER_SHIFT, 6, movetoworkspacesilent, 6
          bind = SUPER_SHIFT, 7, movetoworkspacesilent, 7
          bind = SUPER_SHIFT, 8, movetoworkspacesilent, 8
          bind = SUPER_SHIFT, 9, movetoworkspacesilent, 9
          bind = SUPER_SHIFT, 0, movetoworkspacesilent, 10

          bind = SUPER, right, workspace, e+1
          bind = SUPER, left, workspace, e-1

          bindm = SUPER, mouse:272, movewindow
          bindm = SUPER, mouse:273, resizewindow

          bind = SUPER, M, submap, resize

          binde=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          binde=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

          binde=SUPER, XF86AudioRaiseVolume, exec, brightnessctl s 1%+
          binde=SUPER, XF86AudioLowerVolume, exec, brightnessctl s 1%-

          binde=,XF86MonBrightnessUp, exec, brightnessctl s 1%+
          binde=,XF86MonBrightnessDown, exec, brightnessctl s 1%-

          binde = SUPER_ALT, L, resizeactive, 20 0
          binde = SUPER_ALT, H, resizeactive, -20 0
          binde = SUPER_ALT, K, resizeactive, 0 -20
          binde = SUPER_ALT, J, resizeactive, 0 20

          binde = SUPER_CTRL, L, moveactive, 20 0
          binde = SUPER_CTRL, H, moveactive, -20 0
          binde = SUPER_CTRL, K, moveactive, 0 -20
          binde = SUPER_CTRL, J, moveactive, 0 20

          bind = SUPER_SHIFT, H, movewindow, l
          bind = SUPER_SHIFT, L, movewindow, r
          bind = SUPER_SHIFT, K, movewindow, u
          bind = SUPER_SHIFT, J, movewindow, d

          bind = SUPER,Tab,cyclenext,
          bind = SUPER_SHIFT, F, fullscreen,

          bind = SUPER, Insert, exec, kb_layout
          bind = SUPER, N, exec, toggle_nightmode
          bind = SUPER_SHIFT, W, exec, change_wallpaper
          bind = SUPER, R, exec, change_wallpaper random
          bind = SUPER, C, exec, commander "Commands: " rofi

          bind = SUPER, space, exec, makoctl dismiss -g
          bind = SUPER_SHIFT, space, exec, makoctl restore

          bind = ,f12, exec, grim "$HOME/$(date "+%a_%b_%d_%Y_%H_%M_%S").png" ; notify-send "Screenshot taken."
          bind = SUPER,f12, exec, grim -g "$(slurp)" "$HOME/$(date "+%a_%b_%d_%Y_%H_%M_%S").png" ; notify-send "Screenshot taken."
        '' + (optionalString (config.modules.theme.wallpaper != null) ''
          # ${config.modules.theme.wallpaper} # This will change when the wallpaper changes, changing the file, which triggers a reload for hyprland, which applies the new wallpaper
          exec = set_wallpaper
        '') + (optionalString (config.modules.desktop.gtk.enable == true) ''
          exec = hyprctl setcursor ${config.modules.desktop.gtk.cursorTheme} ${builtins.toString config.modules.desktop.gtk.cursorSize}
        '');
      };
    };
  };
}
