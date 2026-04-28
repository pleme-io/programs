;; github-webhook-flux — typed caixa Servico (service trigger).
;;
;; Receives GitHub push webhooks and triggers FluxCD reconciliation in
;; ~10s instead of the default 5-min poll cycle. Breathable — KEDA HTTP
;; scales to zero when idle.
;;
;; Build / run locally:
;;   nix run github:pleme-io/programs?dir=github-webhook-flux
;;
;; Deploy:
;;   feira deploy --cluster <name> --apply

(defcaixa
  :nome        "github-webhook-flux"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "GitHub webhook receiver that nudges FluxCD into immediate reconciliation (~10s vs 5min poll). Breathable — scales to zero when idle. Service-trigger caixa Servico."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("github" "webhook" "fluxcd" "breathable" "tatara-lisp" "caixa-servico" "service-trigger")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/github-webhook-flux.computeunit.yaml"))
