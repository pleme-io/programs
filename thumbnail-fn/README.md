# thumbnail-fn

Event-driven async function. Subscribes to
`nats:rio.events.photo.uploaded`; for each upload, generates 3
thumbnail variants (small/medium/large WebP) and emits a completion
event.

Demonstrates the **`function` shape** formalized in
[`WASM-PACKAGING.md` §IV.1](https://github.com/pleme-io/theory/blob/main/WASM-PACKAGING.md):
the AWS-Lambda-async-style invocation model. Cold start ~3s
(vs ~30s for a container Lambda); capability-bounded; runs in your
cluster.

## Lifecycle

```
NATS subject empty   → 0 wasm-engine pods, $0 cost
First event arrives  → engine pod boots in ~3s, processes batch, exits
100 events arrive    → operator dispatches in batches of 10; could
                       parallelize across N pods up to maxReplicas
60s idle             → next event boots cold again
```

## Replaces

The container-based image-resize service that's the typical
photo-archive sidecar. ~80 lines of tatara-lisp + a typed
`ThumbnailVariant` schema; no per-tool container; same throughput
because libvips bindings work the same way under WASM.
