# hello-world — packaged as a Nix-native tatara-lisp program.
#
# Run via Nix from anywhere on the internet:
#
#   nix run github:pleme-io/programs?dir=hello-world
#
# Or build a deployable derivation cluster-side:
#
#   nix build github:pleme-io/programs?dir=hello-world
#   ls result/bin/  # → hello-world (a tatara-script wrapper)
#
# The flake delegates to substrate's tlisp2nix builder
# (substrate/lib/build/tatara/program-flake.nix) per
# theory/TATARA-PACKAGING.md §VIII — same pattern every pleme-io
# tatara-lisp program follows.
{
  description = "hello-world — the canonical pleme-io WASM/WASI breathable service example";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    substrate = {
      url = "github:pleme-io/substrate";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tatara-lisp = {
      url = "github:pleme-io/tatara-lisp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, substrate, tatara-lisp, ... }:
    (import "${substrate}/lib/build/tatara/program-flake.nix" {
      inherit nixpkgs flake-utils;
    }) {
      tataraLispFlake = tatara-lisp;
      programs = {
        hello-world = {
          source = {
            type = "local";
            path = ./main.tlisp;
          };
          description =
            "the canonical pleme-io WASM/WASI breathable service — Hello, world!";
        };
      };
    };
}
