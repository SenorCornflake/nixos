{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "commander";
  unpackPhase = "true";
  buildInputs = [
    pkgs.python3
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${./commander.py} $out/bin/commander
    chmod +x $out/bin/commander
  '';
}
