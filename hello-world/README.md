# hello-world

The canonical pleme-io WASM/WASI breathable service. Demonstrates
every layer of [`META-FRAMEWORK.md`](https://github.com/pleme-io/theory/blob/main/META-FRAMEWORK.md):

| Layer | Artifact | Where |
|---|---|---|
| 0 — source | `main.tlisp` (~70 lines) | this directory |
| 1 — artifact | compiled WASM (~2 MiB) | ghcr.io/pleme-io OR cluster cache |
| 2 — typed CR | `ComputeUnit` | `computeunit.yaml` reference |
| 3 — library chart | `pleme-computeunit` (sidecars) | helmworks |
| 4 — consumer chart | `lareira-hello-world` (defaults) | helmworks |
| 5 — deployment | FluxCD HelmRelease | `pleme-io/k8s/clusters/<name>/programs/` |

## What it does

- HTTP service on `:8080` with three routes — `/healthz`, `/hello`, `/hello/:name`.
- Returns a typed JSON greeting using config from `current-config`
  (sourced from the CR's `spec.config`).
- Emits Prometheus counters (`hello_world_requests_total`) and
  histograms (`hello_world_request_duration_seconds`) on `:9090`.
- Identifies itself with the pod name + namespace + cluster name
  (downward API) so distributed-trace style observation works.

## Breathability

- KEDA HTTP add-on intercepts inbound traffic.
- `minReplicas: 0` — full scale-to-zero.
- `cooldownPeriod: 600s` — warm for 10 min after last request.
- Cold start: ~3 seconds (wasmtime instantiate + WASI init).

When the cluster is idle, this service costs zero pods. First request
boots a pod; subsequent requests within 10 min hit the warm pod;
after 10 min idle, scales back to zero.

## Install

### Via Helm (canonical)

```sh
helm install hello-world ./helmworks/charts/lareira-hello-world \
  --namespace tatara-system --create-namespace \
  --set 'pleme-computeunit.enabled=true'
```

Or via FluxCD per
[`theory/FLEET-DECLARATION.md`](https://github.com/pleme-io/theory/blob/main/FLEET-DECLARATION.md)
— add an entry to the cluster's `programs/release.yaml`:

```yaml
- name: hello-world
  module: { source: github:pleme-io/programs/hello-world/main.tlisp?ref=v0.1.0 }
  trigger:
    service:
      port: 8080
      paths: ["/", "/hello", "/healthz"]
      hosts: [hello.quero.cloud]
      breathability: { enabled: true, cooldownPeriod: 600 }
  capabilities:
    - http-in:0.0.0.0:8080
    - kube-downward-api
  config:
    greeting: Hello
    audience: world
```

### Via raw kubectl (reference only)

```sh
kubectl apply -f computeunit.yaml
```

## Test — local, today

The .tlisp file is **runnable today** via tatara-script + the
`http-serve-static` stdlib primitive (added 2026-04-26):

```sh
# In one terminal:
nix run github:pleme-io/tatara-lisp#script -- ./main.tlisp
# [http-serve-static] listening on http://0.0.0.0:8080

# In another terminal:
curl http://localhost:8080/hello
# {"message":"Hello, world!","served-by":"tatara-script"}

curl http://localhost:8080/healthz
# {"module-version":"v0.1.0","served-by":"tatara-script","status":"ok"}
```

This is the same .tlisp the cluster deployment will run; only the
runtime changes (host-side `tatara-script` vs cluster-side
`wasm-engine`).

## Test — cluster (Phase B)

Once `tatara-lisp-script` exposes `--target=wasm32-wasi` and the
wasm-operator publishes:

```sh
curl https://hello.quero.cloud/hello
# {"message":"Hello, world!","served-by":"hello-world-7d8f-abc"}

curl https://hello.quero.cloud/healthz
# {"status":"ok","pod":"hello-world-7d8f-abc","namespace":"tatara-system",...}
```

## Customize

Edit `spec.config` in the consumer chart's values:

```yaml
pleme-computeunit:
  config:
    greeting: "Howdy"
    audience: "partner"
    punctuation: "!"
    debug: true
```

No WASM rebuild. The CR-spec change propagates through FluxCD →
operator → engine pod restart → new greeting served.

## Why this is the canonical example

It exercises every architectural commitment in one place:

| Theory commitment | How hello-world demonstrates |
|---|---|
| [`THEORY.md` Pillar 1](https://github.com/pleme-io/theory/blob/main/THEORY.md) (Lisp + WASM/WASI) | Authored in tatara-lisp, compiled to WASM |
| [`SCRIPTING.md`](https://github.com/pleme-io/theory/blob/main/SCRIPTING.md) (tatara-lisp standard) | Zero bash, zero Rust per-program code |
| [`BREATHABILITY.md`](https://github.com/pleme-io/theory/blob/main/BREATHABILITY.md) (use → spin-up) | minReplicas=0 + cooldown 10min |
| [`WASM-STACK.md`](https://github.com/pleme-io/theory/blob/main/WASM-STACK.md) (4 shapes) | service shape; KEDA HTTP wakes |
| [`WASM-PATTERNS.md`](https://github.com/pleme-io/theory/blob/main/WASM-PATTERNS.md) #42 | HTTP service primitive |
| [`LISP-YAML-CONTROLLERS.md` §V](https://github.com/pleme-io/theory/blob/main/LISP-YAML-CONTROLLERS.md) (V.2 tier) | typed schema + YAML-on-top config |
| [`WASM-PACKAGING.md`](https://github.com/pleme-io/theory/blob/main/WASM-PACKAGING.md) (URL grammar) | github:URL with `?ref=` |
| [`META-FRAMEWORK.md`](https://github.com/pleme-io/theory/blob/main/META-FRAMEWORK.md) (4-layer) | One artifact per layer, no skips |
| [`FLEET-DECLARATION.md`](https://github.com/pleme-io/theory/blob/main/FLEET-DECLARATION.md) | One YAML entry deploys the whole stack |

If a future engineer (or AI agent) wants to see "what does pleme-io
look like end-to-end?" they read the trilogy + come here.
