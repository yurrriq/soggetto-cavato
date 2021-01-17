{
  description = "Carve music from words";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        rec {
          devShell = import ./shell.nix { inherit pkgs; };
          packages.soggetto-cavato = pkgs.callPackage ./. { inherit pkgs; };
          defaultPackage = packages.soggetto-cavato;
          apps.soggetto-cavato = flake-utils.lib.mkApp {
            drv = packages.soggetto-cavato;
            exePath = "/bin/sc";
          };
          defaultApp = apps.soggetto-cavato;
        }
      );
}
