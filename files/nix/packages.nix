{ pkgs ? import <nixpkgs> {} }:

[
  pkgs.python310Full
  pkgs.python310Packages.pip
  pkgs.nodejs-16_x
]
