{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "auto-base16-theme";
  version = "1.0.0";
  buildInputs = [
    pkgs.python3
  ];
  preBuild = ''
    echo "$(echo '#!/usr/bin/env python'; cat AutoBase16Theme.py)" > AutoBase16Theme.py
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp AutoBase16Theme.py $out/bin/auto-base16-theme
    chmod +x $out/bin/auto-base16-theme
  '';
  src = pkgs.fetchFromGitHub {
    owner = "makuto";
    repo = "auto-base16-theme";
    rev = "081ca564c13d71860a2d6fcb6b2ea8770ad7512d";
    sha256 = "021bfgn366vw11w5f5pdbh8xz22glsjakf8xc98rbnwbaw3xs5wf";
  };
}
