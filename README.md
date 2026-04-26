# pleme-io/programs

Tatara-lisp programs that run on the
[`lareira-wasm-platform`](https://github.com/pleme-io/helmworks/tree/main/charts/lareira-wasm-platform)
runtime. Each program is a self-contained `.tlisp` file fetched by URL
per [`theory/WASM-PACKAGING.md`](https://github.com/pleme-io/theory/blob/main/WASM-PACKAGING.md).

## What's here

One program per shape from
[`theory/WASM-STACK.md` §I](https://github.com/pleme-io/theory/blob/main/WASM-STACK.md):

| Program | Shape | Trigger | Replaces |
|---|---|---|---|
| `pvc-autoresizer/` | job | `cron: "*/5 * * * *"` | the Rust watcher in `helmworks/charts/pleme-storage-elastic/image/` |
| `dns-reconciler/` | controller | `watch: dns.pleme.io/DnsReconciler` | ExternalDNS |
| `github-webhook-flux/` | service | `service: { port: 8080 }` | webhook receiver bash scripts |
| `fleet-attestation-sweep/` | program | `oneShot` | ad-hoc `kubectl + jq` sessions |
| `thumbnail-fn/` | function | `event: nats:rio.events.photo.uploaded` | container-based image-resize service |

Each directory: `main.tlisp` (the program) + `README.md` (what it does)
+ `computeunit.yaml` (the wiring CR).

## Dogfood claim

The five programs above demonstrate the entire WASM-STACK contract:

```
Author writes 30-100 lines of tatara-lisp
  → push to GitHub
  → operator applies a 12-line ComputeUnit pointing at github:pleme-io/programs/<dir>/main.tlisp
  → runtime fetches, compiles to WASM, runs
  → resident at idle: 0
```

Total LoC across the five: ~300 lines of `.tlisp` replaces ~3000 lines
of mixed Rust / Go / bash that would otherwise ship as containers.

## Building

```sh
nix build .#pvc-autoresizer       # → ./result/pvc-autoresizer.wasm
nix build .#dns-reconciler        # → ./result/dns-reconciler.wasm
# etc.
```

Phase B prereq — `tatara-lisp-script` must expose a `--target=wasm32-wasi`
flag. Until then `nix build` returns a placeholder; programs are still
referenceable by URL but aren't yet WASM-runnable.

## Running locally without K8s

```sh
nix run pleme-io/tatara-lisp#script -- ./pvc-autoresizer/main.tlisp
```

`tatara-script` already supports `(require ...)` and the rich stdlib;
each program runs natively for development without the wasm-engine.

## Running in-cluster

```sh
kubectl apply -f pvc-autoresizer/computeunit.yaml
```

The `lareira-wasm-platform` operator picks up the CR, resolves the
`module.source` URL (BLAKE3-hashed + cached), and runs.

## Adding a program

1. `mkdir <new-program>/`
2. Write `<new-program>/main.tlisp` — pick a controller macro from
   [`tatara-lisp-controllers/lib/`](https://github.com/pleme-io/tatara-lisp-controllers/tree/main/lib)
   if your shape matches one of the cookbook patterns.
3. Write `<new-program>/computeunit.yaml` — wire the trigger + capabilities.
4. Add a build target in `flake.nix`.
5. Push. Reference via `github:pleme-io/programs/<new-program>/main.tlisp?ref=<tag>`.

## See also

- [`theory/WASM-STACK.md`](https://github.com/pleme-io/theory/blob/main/WASM-STACK.md) — runtime
- [`theory/WASM-PATTERNS.md`](https://github.com/pleme-io/theory/blob/main/WASM-PATTERNS.md) — 49-pattern cookbook
- [`theory/WASM-PACKAGING.md`](https://github.com/pleme-io/theory/blob/main/WASM-PACKAGING.md) — URL grammar + cache
- [`theory/LISP-YAML-CONTROLLERS.md`](https://github.com/pleme-io/theory/blob/main/LISP-YAML-CONTROLLERS.md) — Lisp + YAML authoring
