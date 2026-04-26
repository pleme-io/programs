# pvc-autoresizer

Keep watched PVCs at ~80% utilization.
[Cookbook pattern #1](https://github.com/pleme-io/theory/blob/main/WASM-PATTERNS.md#1-pvc-autoresizer).

## What it does

Every 5 minutes, list every PVC matching the configured selector;
query Prometheus for current usage; if `used/capacity > 0.80`, patch
`spec.resources.requests.storage` to `1.25×` current.

Hard ceiling: `maxSize` (default `100Gi`). Cooldown: 600s between
expansions of the same PVC.

## Replaces

`helmworks/charts/pleme-storage-elastic/image/` — a 280-line Rust
watcher that ships as a 30 MiB OCI image. This program is ~70 lines of
tatara-lisp + a 23-line ComputeUnit; the resulting WASM module is ~2 MiB.

## Configuration

Edit `computeunit.yaml`:

| Field | Default | Meaning |
|---|---|---|
| `triggerAt` | `0.80` | Fraction of capacity that triggers expansion |
| `expandFactor` | `1.25` | Multiplier on current capacity |
| `maxSize` | `100Gi` | Hard ceiling per PVC |
| `cooldownSeconds` | `600` | Min interval between expansions of the same PVC |
| `prometheusUrl` | rio's vmsingle | Prometheus query endpoint |
| `selector` | `breathable=true` | Label selector for PVCs to watch |
| `namespaces` | `[]` (all) | Restrict to specific namespaces |
| `dryRun` | `false` | If `true`, log what would be patched without patching |
