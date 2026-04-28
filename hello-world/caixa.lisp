;; hello-world — the canonical Lisp-authored caixa Servico.
;;
;; Companion to pleme-io/hello-rio (the Rust-authored canonical Servico).
;; Both serve identical JSON on /, /hello, /healthz, and both render to
;; the same Kubernetes ComputeUnit shape — proof that caixa is
;; source-language-agnostic for service-class packages.
;;
;; The implementation is `main.tlisp` — pure tatara-lisp, evaluated by
;; tatara-script (today) or compiled to wasm32-wasip2 via substrate's
;; tlisp2nix builder (Phase B).
;;
;; Build (today):
;;   nix run github:pleme-io/programs?dir=hello-world
;;   curl http://localhost:8080/hello
;;
;; Cluster dispatch:
;;   the typed Servico manifest at servicos/hello-world.computeunit.yaml
;;   declares `module.source: github:pleme-io/programs/hello-world/main.tlisp?ref=v0.1.0`
;;   — the canonical github: URL grammar from theory/WASM-PACKAGING.md §II,
;;   resolved by the wasm-engine on first request.
;;
;; Publish:
;;   `feira publish` (Zig-style git-tag) — caxia consumers pin :tag "v0.1.0".
;;   No OCI image is built or pushed; tatara-script fetches source by URL.

(defcaixa
  :nome        "hello-world"
  :versao      "0.1.0"
  :kind        Servico
  :edicao      "2026"
  :descricao   "Canonical tatara-lisp caixa Servico — the JSON `Hello, world!` reference. Companion to pleme-io/hello-rio (Rust). Demonstrates the eight-phase loop end-to-end on the Lisp source path."
  :repositorio "github:pleme-io/programs"
  :licenca     "MIT"
  :autores     ("pleme-io")
  :etiquetas   ("hello-world" "tatara-lisp" "caixa-servico" "canonical" "breathable" "example")
  :deps        ()
  :deps-dev    ()
  :servicos    ("servicos/hello-world.computeunit.yaml"))
