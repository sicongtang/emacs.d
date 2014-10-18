;;; go-mode-load.el --- automatically extracted autoloads
;;; Commentary:

;; To install go-mode, add the following lines to your .emacs file:
;;   (add-to-list 'load-path "PATH CONTAINING go-mode-load.el" t)
;;   (require 'go-mode-load)
;;
;; After this, go-mode will be used for files ending in '.go'.
;;
;; To compile go-mode from the command line, run the following
;;   emacs -batch -f batch-byte-compile go-mode.el
;;
;; See go-mode.el for documentation.
;;
;; To update this file, evaluate the following form
;;   (let ((generated-autoload-file buffer-file-name)) (update-file-autoloads "go-mode.el"))

;;; Code:


;;;### (autoloads (go-download-play godoc gofmt-before-save go-mode)
;;;;;;  "go-mode" "go-mode.el" (20767 50749))
;;; Generated autoloads from go-mode.el
(require-package 'go-mode)

(autoload 'go-mode "go-mode" "\
Major mode for editing Go source text.

This mode provides (not just) basic editing capabilities for
working with Go code. It offers almost complete syntax
highlighting, indentation that is almost identical to gofmt,
proper parsing of the buffer content to allow features such as
navigation by function, manipulation of comments or detection of
strings.

Additionally to these core features, it offers various features to
help with writing Go code. You can directly run buffer content
through gofmt, read godoc documentation from within Emacs, modify
and clean up the list of package imports or interact with the
Playground (uploading and downloading pastes).

The following extra functions are defined:

- `gofmt'
- `godoc'
- `go-import-add'
- `go-remove-unused-imports'
- `go-goto-imports'
- `go-play-buffer' and `go-play-region'
- `go-download-play'

If you want to automatically run `gofmt' before saving a file,
add the following hook to your emacs configuration:

\(add-hook 'before-save-hook 'gofmt-before-save)

If you're looking for even more integration with Go, namely
on-the-fly syntax checking, auto-completion and snippets, it is
recommended to look at goflymake
\(https://github.com/dougm/goflymake), gocode
\(https://github.com/nsf/gocode) and yasnippet-go
\(https://github.com/dominikh/yasnippet-go)

\(fn)" t nil)

(add-to-list 'auto-mode-alist (cons "\\.go\\'" 'go-mode))

(autoload 'gofmt-before-save "go-mode" "\
Add this to .emacs to run gofmt on the current buffer when saving:
 (add-hook 'before-save-hook 'gofmt-before-save).

Note that this will cause go-mode to get loaded the first time
you save any file, kind of defeating the point of autoloading.

\(fn)" t nil)

(autoload 'godoc "go-mode" "\
Show go documentation for a query, much like M-x man.

\(fn QUERY)" t nil)

(autoload 'go-download-play "go-mode" "\
Downloads a paste from the playground and inserts it in a Go
buffer. Tries to look for a URL at point.

\(fn URL)" t nil)


;;
;; go-autocomplete.el
;; ensure gocode is executable and added to the path(.bash_profile)
;;
(eval-when-compile
  (require 'cl)
  (require 'auto-complete))

;; Close gocode daemon at exit unless it was already running
(eval-after-load "go-mode"
  '(progn
     (let* ((user (or (getenv "USER") "all"))
            (sock (format (concat temporary-file-directory "gocode-daemon.%s") user)))
       (unless (file-exists-p sock)
         (add-hook 'kill-emacs-hook #'(lambda ()
                                        (ignore-errors
                                          (call-process "gocode" nil nil nil "close"))))))))

;(defvar go-reserved-keywords
;  '("break" "case" "chan" "const" "continue" "default" "defer" "else"
;    "fallthrough" "for" "func" "go" "goto" "if" "import" "interface"
;    "map" "package" "range" "return" "select" "struct" "switch" "type" "var")
;  "Go reserved keywords.")

(defun ac-comphist-sort (db collection prefix &optional threshold)
;; redefine to disable sorting
  (let (result
        (n 0)
        (total 0)
        (cur 0))
    (setq result (mapcar (lambda (a)
                           (when (and cur threshold)
                             (if (>= cur (* total threshold))
                                 (setq cur nil)
                               (incf n)
                               (incf cur (cdr a))))
                           (car a))
                         (mapcar (lambda (string)
				   (let ((score (ac-comphist-score db string prefix)))
				     (incf total score)
				     (cons string score)))
				 collection)))
    (if threshold
        (cons n result)
      result)))

(defun ac-go-invoke-autocomplete ()
  (let ((temp-buffer (generate-new-buffer "*gocode*")))
    (unwind-protect
        (progn
          (call-process-region (point-min)
                               (point-max)
                               "gocode"
                               nil
                               temp-buffer
                               nil
                               "-f=emacs"
                               "autocomplete"
                               (or (buffer-file-name) "")
                               (concat "c" (int-to-string (- (point) 1))))
          (with-current-buffer temp-buffer (buffer-string)))
      (kill-buffer temp-buffer))))

(defun ac-go-format-autocomplete (buffer-contents)
  (sort
   (split-string buffer-contents "\n" t)
   (lambda (a b) (string< (downcase a)
                          (downcase b)))))

(defun ac-go-get-candidates (strings)
  (let ((prop (lambda (entry)
		(let ((name (nth 0 entry))
		      (summary (nth 1 entry)))
		  (propertize name
			      'summary summary))))
	(split (lambda (strings)
		 (mapcar (lambda (str)
			   (split-string str ",," t))
			 strings))))
    (mapcar prop (funcall split strings))))

(defun ac-go-action ()
  (let ((item (cdr ac-last-completion)))
    (if (stringp item)
        (message "%s" (get-text-property 0 'summary item)))))

(defun ac-go-document (item)
  (if (stringp item)
      (let ((s (get-text-property 0 'summary item)))
        (message "%s" s)
        nil)))

(defun ac-go-candidates ()
  (ac-go-get-candidates (ac-go-format-autocomplete (ac-go-invoke-autocomplete))))

(defun ac-go-prefix ()
  (or (ac-prefix-symbol)
      (let ((c (char-before)))
        (when (eq ?\. c)
          (point)))))

(ac-define-source go
  '((candidates . ac-go-candidates)
    (candidate-face . ac-candidate-face)
    (selection-face . ac-selection-face)
    (document . ac-go-document)
    (action . ac-go-action)
    (prefix . ac-go-prefix)
    (requires . 0)
    (cache)
    (symbol . "g")))

(add-to-list 'ac-modes 'go-mode)

(add-hook 'go-mode-hook #'(lambda ()
                           (add-to-list 'ac-sources 'ac-source-go)))

;;;***

(provide 'init-go-mode)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; go-mode-load.el ends here
