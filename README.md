# A Modern C Development Environment in Vim 

## Overview

This project uses `vim`, `nix`, and the Language Server Protocol (LSP) to create a simple-to-use, modern C dev environment (that works on macOS). It assumes that you have `nix` installed, `vim 8` or higher, an appropriate `clang`. There is a sample C program that combines "Hello World" with the `gtk4` introductory tutorial for making a simple window. 

It is good practice to use the least complicated tools and techniques, only adding complexity as needed. There are many tools for navigating and exploring a repository of code from `ctags` to `cscope` to `git grep`. Over the years there have also been several convenience features that we take for granted such as `pkg-config`.

 After trying many combinations of such tools and techniques to link libraries and includes to path, the solution here is simple and easy to use. The `nix` used is minimal and easy to understand. One could build on this example as their `nix` experience improves over time. 

## What one gets

- ALE for linting, formatting, and error/warning handling. 
- LSP for code navigation (powered by `compile_commands.json`)
- Asynchronous autocomplete (powered by `compile_commands.json`) 
- Default keybindings for certain LSP functions
- Tab completion set up for `asyncomplete`
- A helper function to swap between headers and source (only for C, though you can modify it as needed). 

## Asynchronous Linting Engine (ALE)

Asynchronous Linting Engine (ALE) has powerful hooks into many major fixers and linters. The ones turned on here are `clang-tidy` and `clang-format`. There are also some C flags to get you started. These should be reasonable starting points for a variety of project setups. More configuration options can be found in the `ALE` plugin. 

NOTE: There is a .clangformat file in the repo to test that functionality. 

## Language Server Protocol (LSP)

The Language Server Protocol (and Asynchronous AutoComplete) is powered by a `compile_commands.json` database. This can be generated in many ways, but `clang` is used here. The basic strategy for generating such a database is to create a database per file and to then concatenate them into a `compile_commands.json` placed in the root of the repo. This is done in the `build.sh` script in a helper function `make-compile-cmds-json-C`. Notice that this function checks that you are in a git repo when you call the script. 

## Asynchronous Autocompletion

The same `compile_commands.json` database that powers the LSP also powers omnicompletion. One can start typing and press `<TAB>` to get an autocomplete dropdown menu. The tag jumping has been as fast as with `ctags` in my experience. 

## VIMRC

The `HOME/vimrc` directory is an excerpt of a vimrc with everything needed to make the workflow work.  It is intended to be added to your primary vimrc. There are default keybindings for LSP functions that work automatically for any Language Server one has set up. Further, the C family of languages has its language server set up. More info on the possible LSP bindings can be found in the `vim-lsp` plugin.

The vim plugins needed are:

- https://github.com/dense-analysis/ale
- https://github.com/rhysd/vim-lsp-ale
- https://github.com/prabirshrestha/vim-lsp
- https://github.com/prabirshrestha/asyncomplete.vim
- https://github.com/prabirshrestha/asyncomplete-lsp.vim

The plugins have a bit of overlap in functionality (for instance `ALE` and `vim-lsp` both have language server capabilities). As such, there are some glue plugins as convenience that set the flags in a way that makes sense for this scheme. 

## Building

The philosophy of this setup is to use the simplest tools until the project demands something more complex. Thus we start with a `build.sh` script. As the project gets more complex, one could extend the principles here to work with tools such as `CMake` as needed. 

Included is a template C project set up to:
    - use nix-shell to handle dependencies
    - generate a `compile_commands.json` database file for use in Language Server Protocol
    - build a minimal working example

There is a `make-env.sh` script that does the same thing as the `shell.nix`. It is there to make it easy to understand how the nix way corresponds with a typical bash shell. Either can be used, though calling `nix-shell` is how one would most likely do things. Note that there is a spot for running your own shell command in the new nix-shell. This could be useful for sourcing aliases, for instance. 

### Steps to build:

    1. Run `nix-shell`  or `nix-shell shell.nix` in root of this repository
    2. Run `./build.sh`

## NOTE: 

    The gtk example is under this license: GNU Lesser General Public License, version 2.1 
    See: https://github.com/GNOME/gtk/blob/main/COPYING for details
