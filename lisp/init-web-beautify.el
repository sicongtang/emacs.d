(require-package 'web-beautify)
;; In addition to CLI arguments, you may pass config to the JS executable via:
;; a .jsbeautifyrc file containing JSON data at any level of the filesystem above $PWD
;;
;; {
;;    "indent_size": 4,
;;    "indent_char": " ",
;;    "indent_level": 0,
;;    "indent_with_tabs": false,
;;    "preserve_newlines": true,
;;    "max_preserve_newlines": 10,
;;    "jslint_happy": false,
;;    "brace_style": "collapse",
;;    "keep_array_indentation": false,
;;    "keep_function_indentation": false,
;;    "space_before_conditional": true,
;;    "break_chained_methods": false,
;;    "eval_code": false,
;;    "unescape_strings": false,
;;    "wrap_line_length": 0
;; }

(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c f") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c f") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c f") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c f") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c f") 'web-beautify-css))


(provide 'init-web-beautify)
