{ lib, ... }:

let
  inherit (lib) mkOption types;
in {
  mkBoolOpt = default: lib.mkOption {
    inherit default;
    example = false;
    type = types.bool;
  };

  mkOpt = type: default:
    mkOption { inherit type default; };
}
