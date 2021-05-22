{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  inherit (pkgs.callPackage ./deps.nix { }) ouryara;
  rules = ./execers.yar;
  targets = [ curl gnused ps ];
in runCommand "yara-matches" { } ''
  binlore_yara()(
    set -x
    ${ouryara}/bin/yara ${rules} $1
  )
  {
    echo ""
    for package in ${toString targets}; do
      echo "Showing yara rule matches for package $package"
      echo ""
      binlore_yara $package/bin
      echo ""
    done
  } > $out
  ''
