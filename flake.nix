{
  description = "pleme-io/programs — tatara-lisp programs for the WASM/WASI runtime";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Phase B prereq: tatara-lisp must expose --target=wasm32-wasi.
    # Once it does, this input drives the build.
    tatara-lisp = {
      url = "github:pleme-io/tatara-lisp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, tatara-lisp }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] (system: let
      pkgs = import nixpkgs { inherit system; };

      # Each program gets a build target that compiles main.tlisp to
      # main.wasm via tatara-lisp-script. Until that flag lands the
      # outputs are placeholder files referencing the source.
      buildProgram = name:
        pkgs.runCommand "${name}.wasm-stub" {} ''
          mkdir -p $out
          cat > $out/${name}.wasm.placeholder <<EOF
          tatara-lisp-script --target=wasm32-wasi placeholder
          source: ${./.}/${name}/main.tlisp
          (Phase B prereq — tatara-lisp's wasm32-wasi target.)
          EOF
        '';

      programs = {
        pvc-autoresizer          = buildProgram "pvc-autoresizer";
        dns-reconciler           = buildProgram "dns-reconciler";
        github-webhook-flux      = buildProgram "github-webhook-flux";
        fleet-attestation-sweep  = buildProgram "fleet-attestation-sweep";
        thumbnail-fn             = buildProgram "thumbnail-fn";
      };
    in {
      packages = programs // {
        default = pkgs.symlinkJoin {
          name = "all-programs";
          paths = builtins.attrValues programs;
        };
      };

      apps = builtins.mapAttrs (name: pkg: {
        type = "app";
        program = "${pkg}/${name}.wasm.placeholder";
      }) programs;

      devShells.default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [ kubectl skopeo jq yq ];
      };
    });
}
