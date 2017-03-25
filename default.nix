{ nixpkgs ? (import <nixpkgs> {}) }:

with nixpkgs.pkgs;

callPackage ./esme.nix {}
