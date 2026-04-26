# github-webhook-flux

Receive GitHub push webhooks at `/git-webhook`, verify HMAC-SHA256
signature, kick the matching FluxCD `GitRepository` to reconcile
immediately. Pushes propagate to the cluster in <10s instead of the
default 5min poll.

[Cookbook pattern #9](https://github.com/pleme-io/theory/blob/main/WASM-PATTERNS.md#9-webhook--fluxcd-reconcile).

## Shape

Service (HTTP listener) with KEDA HTTP scale-to-zero. Cooldown 600s —
webhook bursts (a flurry on push, then quiet for hours) settle to
zero pods between bursts.

## Cluster setup

GitHub side: webhook URL → `https://git-webhook.<cluster>.<domain>/git-webhook`,
content-type `application/json`, secret matching the cluster Secret
`flux-system/github-webhook-secret`.

Cluster side: apply `computeunit.yaml`. The wasm-operator wires the
service via the KEDA HTTP add-on; ingress (Cloudflare Tunnel or
ingress-nginx) routes the inbound URL to the service.

## Replaces

The 100-line `webhook-receiver.go` Go binary commonly deployed for
this. Same behavior; 60 lines of tatara-lisp; scale-to-zero between
push bursts.
