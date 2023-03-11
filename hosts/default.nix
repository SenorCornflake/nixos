{ config, pkgs, lib, ... }:

with lib;
with lib.my;

{
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      auto-optimise-store = true;
    };
  };

  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    layout = "us";
    xkbVariant = "";
    xkbOptions = "keypad:pointerkeys,caps:backspace";
    autoRepeatDelay = 250;
    autoRepeatInterval = 30;
  };
  
  home-manager.useGlobalPkgs = true;
  # TODO: maybe this should be in options.nix?
  home-manager.users."${config.userName}" = {
    xdg = {
      enable = true;
      configHome = config.configHome;
      dataHome = config.dataHome;
      cacheHome = config.users.users."${config.userName}".home + "/.cache/";
    };

    nixpkgs.config.allowUnfree = true;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    psmisc
    ntfs3g
    dosfstools
  ];

  programs.dconf.enable = true;

  services.tlp.enable = !config.services.power-profiles-daemon.enable;
  services.gvfs.enable = true;

  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "Iosevka"
      ];
    })
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    scheherazade
    scheherazade-new
    jetbrains-mono
  ];
}
