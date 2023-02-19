{ config, pkgs, lib, ... }:

with lib;
with lib.my;

{
  options.modules = {
    scripts = mkOpt types.attrs {};
  };

  config = {
    environment.systemPackages = (attrValues config.modules.scripts);
  };
}
