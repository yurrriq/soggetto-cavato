{ nixpkgs ? import ./nixpkgs {} }:

with nixpkgs;

haskell.lib.buildStackProject {
  name = "soggetto-cavato";
  ghc = haskell.packages.ghc802.ghc;
  buildInputs = with darwin.apple_sdk.frameworks; [
    CoreAudio CoreMIDI CoreServices
  ];
}
