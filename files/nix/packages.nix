{ pkgs ? import <nixpkgs> {} }:

[
  pkgs.python310Full
  pkgs.python310Packages.pip
  pkgs.nodejs-16_x
  pkgs.jdk
  pkgs.ruby_3_1
  pkgs.ansible
  pkgs.git
  pkgs.git-lfs
  pkgs.wget
  pkgs.tmux
  pkgs.coreutils-prefixed
  pkgs.rbenv
  pkgs.terraform
  pkgs.kubectl
]
