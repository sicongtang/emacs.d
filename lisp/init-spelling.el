;; You need to install ispell locally, e.g. brew install ispell
(require 'ispell)

(when (executable-find ispell-program-name)
  (require 'init-flyspell))

(provide 'init-spelling)
