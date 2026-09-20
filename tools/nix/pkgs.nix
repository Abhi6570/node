arg:
let
  repo = "https://github.com/NixOS/nixpkgs";
  rev = "a32edd7654519351e48e80372a928df336394670";
  nixpkgs = import (builtins.fetchTarball {
    url = "${repo}/archive/${rev}.tar.gz";
    sha256 = "0dc16crrqxp07nr2nwmv9ph30cb0nnq8zld5syq6p5f65c1pqd26";
  }) arg;
in
# Unstable channel no longer supports Intel architecture for macOS. We can use the 26.05 channel
# to keep testing on that platform for a little longer.
# TODO: remove this when 26.05 is EOL (end of 2026)
if builtins.currentSystem == "x86_64-darwin" then (import ./pkgs-26.05.nix arg) else nixpkgs
// {
  sccache = nixpkgs.sccache.overrideAttrs (old: {
    version = "0.17.0";

    src = old.src.overrideAttrs {
      sha256 = "sha256-QGsDxUAQzAr6Aia5/D21cGbVV0YJyuH3aBmEr9NynXQ=";
    };

    cargoHash = "sha256-Jr4+46/yhcuTC017TA2UZQJUNIBuioI3xZnxxD/rKuc=";
  });
}
