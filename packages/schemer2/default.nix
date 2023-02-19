{ pkgs, ... }:

pkgs.buildGoPackage rec {
  pname = "schemer2";
  version = "0.0.1";
  goPackagePath = "github.com/thefryscorer/schemer2";
  src = pkgs.fetchFromGitHub {
    owner = "thefryscorer";
    repo = "schemer2";
    rev = "89a66cbf40440e82921719c6919f11bb563d7cfa";
    sha256 = "0z1nv9gdswfci6y180slvyx4ba2ifc4ifb1b39mdrik4hg7xba0h";
  };
}
