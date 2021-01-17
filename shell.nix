{ pkgs ? import <nixpkgs> { } }:
let
  pkg = import ./. { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = pkg.nativeBuildInputs ++ (
    with pkgs; (
      [
        cabal-install
        nixpkgs-fmt
      ] ++ (
        with haskellPackages; [
          ormolu
          pointfree
        ]
      )
    )
  );
}
