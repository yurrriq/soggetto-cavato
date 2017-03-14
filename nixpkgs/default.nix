with import <nixpkgs> { };

import (fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "89747d357badd51485a2c893ee3803d49def058b";
  sha256 = "1g2a4bsgckyzbasfv2a17yhbh3v7iqj229hnzxiy7p2vdsznjzi5";
})
