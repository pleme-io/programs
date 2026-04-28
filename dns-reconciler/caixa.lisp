;; dns-reconciler — typed caixa Servico (watch trigger).
;;
;; Replaces ExternalDNS — watches `dns.pleme.io/DnsReconciler` CRs +
;; Service / Ingress and reconciles Cloudflare DNS records via the
;; pangea-cloudflare provider.
;;
;; Build / run locally:
;;   nix run github:pleme-io/programs?dir=dns-reconciler
;;
;; Deploy:
;;   feira deploy --cluster <name> --apply

(defcaixa
  :nome        "dns-reconciler"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "Replaces ExternalDNS for the pleme-io fleet. Watches DnsReconciler CRs + Services + Ingresses, reconciles to Cloudflare DNS via pangea-cloudflare. Watch-trigger caixa Servico."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("dns" "cloudflare" "controller" "tatara-lisp" "caixa-servico" "watch-trigger")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/dns-reconciler.computeunit.yaml"))
