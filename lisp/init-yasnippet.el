(require-package 'yasnippet)

;; personal snippets --> https://github.com/AndreaCrotti/yasnippet-snippets
;; yasmate snippets --> https://github.com/capitaomorte/yasmate

;;(setq yas-snippet-dirs
;;      '("~/.emacs.d/snippets"                 ;; personal snippets
;;       ;;"/path/to/some/collection/"           ;; foo-mode and bar-mode snippet collection
;;        "~/.emacs.d/yasnippet/yasmate/snippets" ;; the yasmate collection
;;        "~/.emacs.d/yasnippet/snippets"         ;; the default collection
;;        ))

;; By Default
;; Add your own snippets to ~/.emacs.d/snippets by placing files there or invoking yas-new-snippet.

(yas-global-mode 1)

(provide 'init-yasnippet)