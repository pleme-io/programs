# dns-reconciler

Reconcile K8s Services + Ingresses with the `dns.pleme.io/host`
annotation against a DNS provider zone.
[Cookbook pattern #2](https://github.com/pleme-io/theory/blob/main/WASM-PATTERNS.md#2-dns-reconciler).

## Authoring shape

[V.2 from `LISP-YAML-CONTROLLERS.md` §V](https://github.com/pleme-io/theory/blob/main/LISP-YAML-CONTROLLERS.md):
~30 lines of Lisp + a YAML CR with declarative rules and an
optional Lisp escape hatch per rule.

The `defrule-driven-controller` macro from
[`pleme-io/tatara-lisp-controllers`](https://github.com/pleme-io/tatara-lisp-controllers)
auto-generates the CRD, K8s informers, dispatch loop, and status
propagation.

## Apply

```sh
# 1. The controller (one-time):
kubectl apply -f computeunit.yaml

# 2. The policy CR (operator-edited):
kubectl apply -f https://github.com/pleme-io/tatara-lisp-controllers/blob/main/examples/dns-reconciler/dns-reconciler.yaml
```

## Replaces

ExternalDNS — comparable feature set, ~80 lines of tatara-lisp +
controller-macro instead of ~50K lines of Go. Scale-to-zero between
events; idle resident: 0 MiB.
