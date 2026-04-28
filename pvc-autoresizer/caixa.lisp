;; pvc-autoresizer — typed caixa Servico (cron trigger).
;;
;; Replaces the legacy pleme-storage-elastic Rust controller. Every 5
;; minutes, scans PVCs labeled `breathable: "true"`, queries Prometheus
;; for usage, expands by `expandFactor` when usage crosses `triggerAt`.
;; Cron-trigger caixa — emitted as a CronJob by the wasm-operator.
;;
;; Build / run locally:
;;   nix run github:pleme-io/programs?dir=pvc-autoresizer
;;
;; Deploy:
;;   feira deploy --cluster <name> --apply

(defcaixa
  :nome        "pvc-autoresizer"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "Periodic PVC autoresizer — replaces the pleme-storage-elastic Rust controller. Scans `breathable: true` PVCs every 5 minutes and expands them when Prometheus reports usage above the trigger threshold. Cron-trigger caixa Servico."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("storage" "pvc" "elasticity" "tatara-lisp" "caixa-servico" "cron-trigger")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/pvc-autoresizer.computeunit.yaml"))
