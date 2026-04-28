;; fleet-attestation-sweep — typed caixa Servico (oneShot trigger).
;;
;; Walks every cluster in the fleet, asks tameshi for the BLAKE3
;; attestation root, verifies signatures, and emits a typed report.
;; Invoked on demand by an operator (or by a higher-level audit
;; pipeline); not periodic.
;;
;; Build / run locally:
;;   nix run github:pleme-io/programs?dir=fleet-attestation-sweep
;;
;; Deploy:
;;   feira deploy --cluster <name> --apply

(defcaixa
  :nome        "fleet-attestation-sweep"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "On-demand attestation sweep across the pleme-io cluster fleet — BLAKE3 root verification via tameshi. OneShot-trigger caixa Servico."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("attestation" "tameshi" "audit" "tatara-lisp" "caixa-servico" "oneshot-trigger")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/fleet-attestation-sweep.computeunit.yaml"))
