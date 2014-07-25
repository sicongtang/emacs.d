;; ac-helm depends on popup/helm
(require-package 'popup)
(require-package 'ac-helm)

(global-set-key (kbd "C-:") 'ac-complete-with-helm)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)

(provide 'init-ac-helm)
