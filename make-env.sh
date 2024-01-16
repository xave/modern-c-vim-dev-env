#!/usr/bin/env bash

nix-shell -p pkg-config gtk4 glib --command echo "Nix Shell Initialized"

#^------below is equivalent to this bash script above------v

#{ pkgs ? import <nixpkgs> {} }:
#  pkgs.mkShell {
#    # nativeBuildInputs is usually what you want -- tools you need to run
#    nativeBuildInputs = with pkgs.buildPackages; [
#      pkg-config
#      gtk4
#      glib
#    ];
#    shellHook =
#      ''
#      echo "Nix Shell Initialized"
#      '';
#  }
