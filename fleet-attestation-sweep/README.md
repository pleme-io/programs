# fleet-attestation-sweep

One-shot program that re-verifies every pleme-io cluster's tameshi
attestation chain across all `PangeaArchitecture` resources. Useful
for periodic compliance audits or after a tameshi key rotation.

Shape: `program` (one-shot) — runs once when applied, writes a
structured report to `.status`, deletes itself after 60s.

## Usage

```sh
# Verify default cluster set:
kubectl apply -f computeunit.yaml

# Override per-invocation cluster list:
kubectl apply -f computeunit.yaml \
  --dry-run=client -o yaml \
  | yq '.spec.trigger.oneShot.args = ["--clusters=plo,rio"]' \
  | kubectl apply -f -

# Watch the result:
kubectl wait --for=condition=Succeeded -n tatara-system \
  computeunit/fleet-attestation-sweep --timeout=5m
kubectl get computeunit -n tatara-system fleet-attestation-sweep -o yaml
```

## Replaces

Manual sessions of `kubectl get pa -A | xargs -I {} tameshi verify-chain {}`
across multiple `--context=` switches. Same logic; 50 lines of tatara-lisp;
typed report instead of grep-able shell output.
