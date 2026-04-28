;; convergence-controller — typed caixa Servico (watch trigger).
;;
;; The pleme-io tatara-lisp Process reconciler. Watches
;; `tatara.pleme.io/Process` CRs and reconciles them per the
;; convergence-vs-control distinction in theory/THEORY.md §IV.
;;
;; Build / run locally:
;;   nix run github:pleme-io/programs?dir=convergence-controller
;;
;; Deploy:
;;   feira deploy --cluster <name> --apply
;;
;; The fleet manifest at clusters/<name>/programs/release.yaml carries
;; the entry rendered by `caixa-flux::programs_yaml_entry` from the
;; servicos/ manifest.

(defcaixa
  :nome        "convergence-controller"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "Reconciler for `tatara.pleme.io/Process` CRs — Phase α replacement for the legacy tatara-reconciler. Demonstrates the watch-trigger shape end-to-end."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("controller" "reconciler" "tatara-lisp" "caixa-servico" "watch-trigger")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/convergence-controller.computeunit.yaml"))
