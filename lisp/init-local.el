;; enable line number on editor
;; (global-linum-mode t)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
;; disable auto-save-mode
(setq auto-save-default nil)

(provide 'init-local)
