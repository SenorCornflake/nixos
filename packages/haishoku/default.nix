{ pkgs, ... }:

let
  inherit (pkgs.python3Packages) buildPythonPackage;
in

buildPythonPackage rec {
  name = "haishoku";
  version = "1.1.8";
  propagatedBuildInputs = with pkgs; [
    python3Packages.setuptools
    python3Packages.pillow
  ];
  src = pkgs.fetchurl {
    url = "https://github.com/LanceGin/haishoku/archive/refs/tags/v1.1.8.tar.gz";
    sha256 = "1xlck1aimcgvkqmdhz7n0xyipnj1j2gj997620c1x0q570p7x0lx";
  };
}

