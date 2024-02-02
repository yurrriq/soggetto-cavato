{
  description = "Carve music from words";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    music-suite = {
      url = "github:music-suite/music-suite";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    pre-commit-hooks-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:cachix/pre-commit-hooks.nix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs = inputs@{ self, flake-parts, music-suite, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        overlays.default = _final: prev: {
          haskellPackages = prev.haskellPackages.override {
            overrides = _hself: hsuper:
              let hlib = prev.haskell.lib; in {
                music-suite =
                  hlib.dontHaddock
                    (hlib.dontCheck
                      (hsuper.callCabal2nix "music-suite" music-suite { }));
                soggetto-cavato = hsuper.callCabal2nix "soggetto-cavato" self { };
              };
          };
        };
      };

      systems = [ "x86_64-linux" ];

      perSystem = { config, pkgs, self', system, ... }: {
        _module.args.pkgs = import nixpkgs {
          overlays = [ self.overlays.default ];
          inherit system;
        };

        apps.default = self'.apps.soggetto-cavato;
        apps.soggetto-cavato = {
          program = self'.packages.default;
          type = "app";
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.pre-commit.devShell
          ];

          nativeBuildInputs = with pkgs; [
            abcm2ps
            cabal-install
            ghc
            ghcid
            haskell-language-server
          ] ++ (with haskellPackages; [
            apply-refact
            hpack
            hlint
            ormolu
            pointfree
          ]) ++ self'.packages.default.nativeBuildInputs;
        };

        packages = {
          default = self'.packages.soggetto-cavato;
          inherit (pkgs.haskellPackages) soggetto-cavato;
        };

        pre-commit.settings.hooks = {
          treefmt.enable = true;
        };

        treefmt = {
          projectRootFile = ./flake.nix;
          programs = {
            deadnix.enable = true;
            hlint.enable = true;
            nixpkgs-fmt.enable = true;
            ormolu.enable = true;
            prettier.enable = true;
          };
        };
      };
    };
}
