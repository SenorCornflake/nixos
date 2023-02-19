{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin ":r" ''
      pushd /etc/nixos
      git add .
      sudo nixos-rebuild switch --flake .# --impure
      popd
    '')
    (writeShellScriptBin ":u" ''
      pushd /etc/nixos
      git add .
      nix flake update
      popd
    '')
  ];
}
