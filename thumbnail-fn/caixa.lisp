;; thumbnail-fn — typed caixa Servico (event trigger).
;;
;; Subscribes to NATS subject `rio.events.photo.uploaded`, generates a
;; thumbnail per event, writes the result back to object storage. Pure
;; function-shape compute — no long-lived state, scales with batch size.
;;
;; Build / run locally:
;;   nix run github:pleme-io/programs?dir=thumbnail-fn
;;
;; Deploy:
;;   feira deploy --cluster <name> --apply

(defcaixa
  :nome        "thumbnail-fn"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "Event-driven thumbnail generator — subscribes to NATS uploaded-photo events, writes thumbnails to object storage. Function-shape compute, scales with batch size. Event-trigger caixa Servico."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("nats" "event-driven" "image" "tatara-lisp" "caixa-servico" "event-trigger")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/thumbnail-fn.computeunit.yaml"))
