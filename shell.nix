#run by typing `nix-shell` or `nix-shell shell.nix`

{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
      pkg-config 
      gtk4 
      glib
    ];
    shellHook =
      ''
      echo "Nix Shell Initialized"
      '';
  }

#^------above is equivalent to this bash script below------v

# make-env.sh
#
##!/usr/bin/env bash
#
#nix-shell -p pkg-config gtk4 glib --command echo "Nix Shell Initialized"

