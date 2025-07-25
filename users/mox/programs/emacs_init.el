 ;; functions

(defun forward-to-separator()
  "Move to the next separator like in the every NORMAL editor"
  (interactive)
  (let ((my-pos (re-search-forward separators-regexp)))
    (goto-char my-pos)))

(defun backward-to-separator()
  "Move to the previous separator like in the every NORMAL editor"
  (interactive)
  (let ((my-pos (re-search-backward separators-regexp)))
    (goto-char my-pos)))


(defun forward-to-separator-select()
  "Move to the next separator like in the every NORMAL editor"
  (interactive "^")
  (let ((my-pos (re-search-forward separators-regexp)))
    (goto-char my-pos)))

(defun backward-to-separator-select()
  "Move to the previous separator like in the every NORMAL editor"
  (interactive "^")
  (let ((my-pos (re-search-backward separators-regexp)))
    (goto-char my-pos)))

(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position))
  (next-line)
  (move-beginning-of-line))

(defun c++-spelling-hook ()
  (flyspell-prog-mode)
  (global-set-key (kbd "M-s M-s") 'flyspell-buffer)
  )

(defun fill-sentence ()
  (interactive)
  (save-excursion
    (or (eq (point) (point-max)) (forward-char))
    (forward-sentence -1)
    (indent-relative t)
    (let ((beg (point))
          (ix (string-match "LaTeX" mode-name)))
      (forward-sentence)
      (if (and ix (equal "LaTeX" (substring mode-name ix)))
          (LaTeX-fill-region-as-paragraph beg (point))
        (fill-region-as-paragraph beg (point))))))

(defun my-mmm-markdown-auto-class (lang &optional submode)
  "Define a mmm-mode class for LANG in `markdown-mode' using SUBMODE.
     If SUBMODE is not provided, use `LANG-mode' by default."
  (let ((class (intern (concat "markdown-" lang)))
        (submode (or submode (intern (concat lang "-mode"))))
        (front (concat "^```" lang "[\n\r]+"))
        (back "^```"))
    (mmm-add-classes (list (list class :submode submode :front front :back back)))
    (mmm-add-mode-ext-class 'markdown-mode nil class)))

;; marker improvements came from stack overflow snippets:
;; https://stackoverflow.com/questions/3393834/how-to-move-forward-and-backward-in-emacs-mark-ring

(defun marker-is-point-p (marker)
  "test if marker is current point"
  (and (eq (marker-buffer marker) (current-buffer))
       (= (marker-position marker) (point))))
 
(defun push-mark-maybe ()
  "push mark onto `global-mark-ring' if mark head or tail is not current location"
  (if (not global-mark-ring) (error "global-mark-ring empty")
    (unless (or (marker-is-point-p (car global-mark-ring))
                (marker-is-point-p (car (reverse global-mark-ring))))
      (push-mark))))

(defun push-local-mark-maybe ()
  "push mark onto `mark-ring' if mark head or tail is not current location"
  (if (not mark-ring) (error "mark-ring empty")
    (unless (or (marker-is-point-p (car mark-ring))
                (marker-is-point-p (car (reverse mark-ring))))
      (push-mark))))


;; improve functionality of local markers
(defun backward-local-mark ()
  "use `pop-to-mark-command', pushing current point if not on ring."
  (interactive)
  (push-local-mark-maybe)
  (when (marker-is-point-p (car mark-ring))
    (call-interactively 'pop-to-mark-command))
  (call-interactively 'pop-to-mark-command))

(defun forward-local-mark ()
  "hack `pop-to-mark-command' to go in reverse, pushing current point if not on ring."
  (interactive)
  (push-local-mark-maybe)
  (setq mark-ring (nreverse mark-ring))
  (when (marker-is-point-p (car mark-ring))
    (call-interactively 'pop-to-mark-command))
  (call-interactively 'pop-to-mark-command)
  (setq mark-ring (nreverse mark-ring)))

;; improve functionality of global markers
(defun backward-global-mark ()
  "use `pop-global-mark', pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark))

(defun forward-global-mark ()
  "hack `pop-global-mark' to go in reverse, pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (setq global-mark-ring (nreverse global-mark-ring))
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark)
  (setq global-mark-ring (nreverse global-mark-ring)))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defvar eldoc-fancy-active nil)

(defun corfu-next-doc ()
  "performs corfu-next and also summons documentation"
  (interactive)
  (corfu-next)
  (corfu-info-documentation)
  )

(defun corfu-previous-doc ()
  "performs corfu-next and also summons documentation"
  (interactive)
  (corfu-previous)
  (corfu-info-documentation)
  )

(defun eldoc-test-delete-windows ()
  "`eldoc' but uses the echo area by default and a prefix will swap to a buffer."
  (interactive)
  (progn
    (setq eldoc-fancy-active
	  (if eldoc-fancy-active nil t))
    (delete-other-windows)      
    )
  )

(defun eldoc-fancy ()
  "`eldoc' but uses the echo area by default and a prefix will swap to a buffer."
  (interactive)
  (progn
    (setq eldoc-fancy-active
	  (if eldoc-fancy-active nil t))
    (setq eldoc-display-functions
	  (if eldoc-fancy-active '(eldoc-display-in-buffer) '(eldoc-display-in-echo-area)))
    (if eldoc-fancy-active
	(progn
	  (define-key corfu-map (kbd "C-p") 'corfu-previous-doc)
	  (define-key corfu-map (kbd "C-n") 'corfu-next-doc)
	  (define-key corfu-map (kbd "M-p") 'corfu-previous-doc)
	  (define-key corfu-map (kbd "M-n") 'corfu-next-doc)
	  )
      (progn
	(define-key corfu-map (kbd "C-p") 'corfu-previous)
	(define-key corfu-map (kbd "C-n") 'corfu-next)
	(define-key corfu-map (kbd "M-p") 'corfu-previous)
	(define-key corfu-map (kbd "M-n") 'corfu-next)
	)
      )
    (if eldoc-fancy-active (eldoc t) (delete-other-windows))
    )
  )

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; packages - use-package declarations

;; Enable Vertico.
(use-package vertico
  :ensure t
  :config
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :config
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :ensure t
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  (tab-always-indent 'complete)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  :config
  (hl-line-mode))

;; Example configuration for Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ;; ("C-c M-x" . consult-mode-command)
         ;; ("C-c h" . consult-history)
         ;; ("C-c k" . consult-kmacro)
         ;; ("C-c m" . consult-man)
         ;; ("C-c i" . consult-info)
         ;; ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ;; ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ;; ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ;; ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ;; ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ;; ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ;; ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ;; ("M-#" . consult-register-load)
         ;; ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ;; ("C-M-#" . consult-register)
         ;; Other custom bindings
         ;; ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ;; ("M-g e" . consult-compile-error)
         ;; ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ;; ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ;; ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ;; ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ;; ("M-g m" . consult-mark)
         ;; ("M-g k" . consult-global-mark)
         ;; ("M-g i" . consult-imenu)
         ;; ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ;; ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ;; ("M-s c" . consult-locate)
         ;; ("M-s g" . consult-grep)
         ;; ("M-s G" . consult-git-grep)
         ;; ("M-s r" . consult-ripgrep)
         ("C-s" . consult-line)
         ;; ("M-s L" . consult-line-multi)
         ;; ("M-s k" . consult-keep-lines)
         ;; ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ;; ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ;; ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ;; ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ;; ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ;; ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         ;; :map minibuffer-local-map
         ;; ("M-s" . consult-history)                 ;; orig. next-matching-history-element
              ;; ("M-r" . consult-history))                ;; orig. previous-matching-history-element
	      )

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  ;; :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  ;; (advice-add #'register-preview :override #'consult-register-window)
  ;; (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  ;; (setq xref-show-xrefs-function #'consult-xref
        ;; xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  ;; :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  ;; (consult-customize
   ;; consult-theme :preview-key '(:debounce 0.2 any)
   ;; consult-ripgrep consult-git-grep consult-grep consult-man
   ;; consult-bookmark consult-recent-file consult-xref
   ;; consult--source-bookmark consult--source-file-register
   ;; consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   ;; :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  ;; (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package orderless
  :ensure t
  :custom
  (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  :config
  (setq completion-styles '(orderless)
	completion-category-defaults nil
	completion-category-overrides '((file (styles . (partial-completion)))))
  (setq orderless-matching-styles '(orderless-flex))
  (setq orderless-affix-dispatch-alist
	'((37 . char-fold-to-regexp)
	  (33 . orderless-not)
	  (38 . orderless-annotation)
	  (44 . orderless-initialism)
	  (61 . orderless-literal)
	  (94 . orderless-literal-prefix)
	  (124 . orderless-regexp)))
  )

(use-package marginalia
  :ensure t
  :after vertico
  :bind
  (:map minibuffer-local-map
	("M-A" . marginalia-cycle))
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode))

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt)      ;; Preselect the prompt

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))
  :config
  (global-corfu-mode)
  (corfu-terminal-mode))

;; languages

  ;; eglot section
(require 'eglot)

(use-package bazel
  :ensure t
  )

(defun bazel-show-consuming-rule-custom ()
  "Customized from bazel-mode to make more flexible;
Find the definition of the rule consuming the current file.
The current buffer must visit a file, and the file must be in a
Bazel workspace.  Use ‘xref-show-definitions-function’ to display
the rule definition.  Right now, perform a best-effort attempt
for finding the consuming rule by a textual search in the BUILD
file."
  (interactive)
  (let* ((source-file (or buffer-file-name
                          (user-error "Buffer doesn’t visit a file")))
         (root (or (bazel--workspace-root source-file)
                   (user-error "File is not in a Bazel workspace")))
         (directory (or (bazel--package-directory source-file root)
                        (user-error "File is not in a Bazel package")))
         (package (or (bazel--package-name directory root)
                      (user-error "File is not in a Bazel package")))
         (build-file (or (bazel--locate-build-file directory)
                         (user-error "No BUILD file found")))
         (relative-file (file-relative-name source-file directory))
         (case-fold-file (file-name-case-insensitive-p source-file))
         (rule (or (bazel--consuming-rule-custom build-file relative-file
						 case-fold-file nil)
                   (user-error "No rule for file %s found" relative-file)))
         ;; We press ‘xref-find-definitions’ into service for finding and
         ;; showing the rule.  For that to work, our Xref backend must be found
         ;; unconditionally.
         (xref-backend-functions (list (lambda () 'bazel-mode))))
    (xref-find-definitions
     ;; Create a target identifier similar to what
     ;; ‘xref-backend-identifier-at-point’ returns.
     (propertize (bazel--canonical nil package rule)
                 'bazel-mode-workspace root)))
  nil)

(defun extract-glob-strings (glob-definition-string)
  (let (
	(glob-contents-string (string-match "glob\(\[(.*)\]\)" glob-definition-string))
	(glob-contents-split (split-string glob-contents-string ","))
	)
    (progn
      )
  )

(defun bazel--consuming-rule-custom (build-file source-file case-fold-file only-tests)
  "Customized from bazel-mode to make more flexible;
Return the name of the rule in BUILD-FILE that consumes SOURCE-FILE.
If CASE-FOLD-FILE is non-nil, ignore filename case when
searching.  If ONLY-TESTS is non-nil, look only for test rules.
Return nil if no consuming rule was found."
  (cl-check-type build-file string)
  (cl-check-type source-file string)
  ;; Prefer a buffer that’s already visiting BUILD-FILE.
  (bazel--with-file-buffer existing build-file
    (unless existing (bazel-build-mode))  ; for correct syntax tables
    (let ((case-fold-search nil)
          (search-spaces-regexp nil))
      (save-excursion
        ;; Don’t widen; if the rule isn’t found within the accessible portion of
        ;; the current buffer, that’s probably what the user wants.
        (goto-char (point-min))
        ;; We perform a simple textual search for rules with “srcs” attributes
        ;; that contain references to SOURCE-FILE.  That’s in no way exact, but
        ;; faster than invoking “bazel query”, and most BUILD files are regular
        ;; enough for this approach to give acceptable results.
        (cl-block nil
          (while (let ((case-fold-search case-fold-file))
                   (re-search-forward (rx-to-string `(seq (group (any ?\" ?\'))
                                                          (? ?:) ,source-file
                                                          (backref 1)))
                                      nil t))
            (let ((begin (match-beginning 0))
                  (end (match-end 0)))
              (goto-char begin)
              (python-nav-up-list -1)  ; move to start of attribute value
              (when (looking-back
                     (rx symbol-start "srcs" (* blank) ?= (* blank))
                     (line-beginning-position))
                (when-let ((rule-name (bazel-mode-current-rule-name)))
                  (when (or (not only-tests) (bazel--in-test-rule-p))
                    (cl-return rule-name))))
              ;; Ensure we don’t loop forever if we ended up in a weird place.
              (goto-char end)))

	  ;; fallback to first matching glob in a srcs
	  (while (let ((case-fold-search case-fold-file))
		   (re-search-forward "glob\([^\)]\)" nil t))
            (let ((begin (match-beginning 0))
                  (end (match-end 0))
		  (globs (extract-glob-strings (match-string 0))))
	      
              (goto-char begin)
              (python-nav-up-list -1)  ; move to start of attribute value
              (when (looking-back
                     (rx symbol-start "srcs" (* blank) ?= (* blank))
                     (line-beginning-position))
                (when-let ((rule-name (bazel-mode-current-rule-name)))
		  (when

		  
                  (when (or (not only-tests) (bazel--in-test-rule-p))
                    (cl-return rule-name))))
              ;; Ensure we don’t loop forever if we ended up in a weird place.
              (goto-char end)))

	  )))))


;; next deal is that we want to add some bazel utils:
;; - suped up version of show-consuming-rule
;;   (presently it only works for explicit rules not globs)
;;   - can make something reasonable with falling back to just showing the build file using bazel-find-build-file
;; - extract target at point - this I can probably hack with some basic string manip
;; honestly... this LSP is sortof 'good enough' but it's significantly short of the
;; professional bazel LSPs. Somethign to contribute to if I have a lot of extra time.

(use-package jsonnet-mode
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               '(jsonnet-mode . ("jsonnet-ls"
				 :initializationOptions
				 ;; TODO: this is kindof garbage. Fix it.
				 (:format_engine "bin-jsonnetfmt-stdio")
				 )))
  :mode (
         ("\\.libsonnet\\'" . libsonnet-mode)
         ("\\.jsonnet\\'" . jsonnet-mode)
         ("\\.jsonnet.TEMPLATE\\'" . jsonnet-mode)
         )
  :hook
  (jsonnet-mode . (lambda()
		    flymake-mode
                    (eglot-ensure))))

(use-package nix-mode
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
	       '(nix-mode . ("nil" "--stdio")))
  :hook
  (nix-mode . (lambda()
		flymake-mode
		(eglot-ensure))))

(use-package python-mode
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
	       '(python-mode . ("pyright-langserver" "--stdio")))
  :hook
  (python-mode . (lambda()
		flymake-mode
		(eglot-ensure))))

(use-package rust-mode
  :hook
  (rust-mode . (lambda()
		 flymake-mode
		 (eglot-ensure))))

(use-package scala-mode
  :interpreter ("scala" . scala-mode)
  :hook
  (scala-mode (lambda()
		flymake-mode
		(eglot-ensure))))

(use-package markdown-mode
  :ensure t
  :init
  (setq markdown-command "multimarkdown")
  (setq markdown-hide-markup t))

;; extra hooks
(add-hook 'emacs-lisp-mode-hook 'flymake-mode)
(add-hook 'sh-mode-hook
	  '(lambda()
	     flymake-mode
	     (add-to-list 'eglot-server-programs
			  '(sh-mode . ("bash-language-server" "start")))
	     ))

;; keybindings
;; (global-unset-key (kbd "<down>"))
;; (global-unset-key (kbd "<left>"))
;; (global-unset-key (kbd "<right>"))
;; (global-unset-key (kbd "<up>"))
;; (global-unset-key (kbd "C-<left>"))
;; (global-unset-key (kbd "C-<right>"))
;; (global-unset-key (kbd "C-<up>"))
;; (global-unset-key (kbd "C-<down>"))
;; (global-unset-key (kbd "M-;"))
;; (global-unset-key (kbd "M-c"))
;; (global-unset-key (kbd "C-?"))
;; (global-unset-key (kbd "M-."))
;; (global-unset-key (kbd "M-TAB"))
;; (global-unset-key (kbd "C-i"))
;; (global-unset-key (kbd "M-s"))
;; (global-unset-key (kbd "M-j"))
;; (global-unset-key (kbd "M-i"))
;; (global-unset-key (kbd "M-o"))
;; (global-unset-key (kbd "M-I"))
;; (global-unset-key (kbd "M-O"))

;; (global-set-key (kbd "C-?") 'eldoc-fancy)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-j") 'browse-url-at-point)
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)
(global-set-key (kbd "C-x h") 'eldoc-fancy)
;; (global-set-key (kbd "M-;") 'toggle-comment-on-line)
(global-set-key (kbd "M-N") (lambda () (interactive) (next-line 5)))
(global-set-key (kbd "M-P") (lambda () (interactive) (previous-line 5)))
(global-set-key (kbd "M-TAB") 'eglot-format-buffer)
(global-set-key (kbd "M-SPC") 'completion-at-point)
(global-set-key (kbd "M-b") 'backward-to-separator)
(global-set-key (kbd "M-f") 'forward-to-separator)
(global-set-key (kbd "M-h") 'backward-kill-word)
(global-set-key (kbd "M-i") 'backward-local-mark)
(global-set-key (kbd "M-j") 'find-file-at-point)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-o") 'forward-local-mark)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-q") 'fill-sentence)
(global-set-key (kbd "M-s") 'counsel-git-grep)
(global-set-key (kbd "C-TAB") 'eglot-format)
(global-set-key (kbd "M-`") 'keyboard-escape-quit)

;; settings
(global-display-line-numbers-mode)
(global-hl-line-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq show-paren-delay 0)
(setq eldoc-idle-delay 0.05)

(setq linum-format "%4d\u2502")
(setq separators-regexp "[\-'\"();:,.\\/?!@#%&*+= ]")


;; theme

(load-theme 'mox)

(set-face-attribute 'line-number-current-line nil
		    :foreground "#22DD22"
		    :weight 'bold)
(set-face-attribute 'line-number nil
		    :foreground "#555555")
(set-face-attribute 'show-paren-match nil
		    :background "#555555")
(set-face-attribute 'show-paren-match-expression nil
		    :background "#555555")
(set-face-attribute 'show-paren-match-expression nil
		    :background "#555555")
(set-face-attribute 'show-paren-mismatch nil
		    :background "#702191")

;; modeline
(defun trim (string_content target_width left_portion right_portion)
    (if (< (length string_content) target_width)
	string_content
      (concat
       (substring string_content 0 (- (truncate (* left_portion target_width)) 1))
       "…"
       (substring string_content
		  (- (length string_content) (truncate (* right_portion target_width)))
		  (length string_content))
       )
      )
    )

(defun current-buffer-file-from-project (target_width)
  "extracts the path to the current file based on eglot project root"
  (let* ((filename (buffer-file-name))
         (eglot-project (or (nth 2 (project-current))
			    (expand-file-name default-directory)))
	 (processed-buffer-name
	  (if (and filename (file-exists-p filename) eglot-project)
	      (file-relative-name filename eglot-project)
	    (buffer-name))
	  ))
    (trim processed-buffer-name target_width 0.3 0.7)
    )
  )

(defun get-modified-marker ()
  "produces a marker   if the current buffer is modified 󰄱  otherwise"
  (if (buffer-modified-p)
      " "
    " "
    )
  )

(defun git+-branch (&optional buffer)
  "Return Git branch for file of BUFFER.
BUFFER defaults to the current buffer."
  (let ((fn (buffer-file-name (or buffer (current-buffer)))))
    (with-temp-buffer 
      (and (eq (vc-backend fn)
           'Git)
       (eq (vc-git-command t 0 fn "branch" "--show-current") 0)
       (buffer-substring-no-properties (point-min) (line-end-position 0))))))

(defun borderize (content foreground background border)
  (concat
   (if (and border background)
       (propertize
	"▏"
	'face `(:foreground ,border :background ,background)
	)
     "▏"
     )
   (if (and foreground background)
     (propertize
      content
      'face `(:foreground ,foreground :background ,background :weight bold)
      )
     content
   )
   (if (and border background)
       (propertize
	"▕"
	'face `(:foreground ,border :background ,background)
	)
     "▕"
     )
   )
  )

(defun mode-line-renderer (left right filler_char)
  (let ((available-width
         (- (window-total-width)
            (+ (length (format-mode-line left))
               (length (format-mode-line right))))))
    (concat left
            (string-replace " " filler_char (format (format "%%%ds" available-width) ""))
            right)))

(setq-default mode-line-format
	      '(
		(:eval (mode-line-renderer
		 (concat
		  (propertize (get-modified-marker) 'face
			      '(:foreground "#eeeeee" :background "#2A2A2A"))
		  (propertize "▕" 'face
			      '(:foreground "#eeeeee" :background "#2A2A2A"))
		  (propertize "─" 'face '(:foreground "#eeeeee"))
		  (borderize (current-buffer-file-from-project
			      (truncate (* .4 (window-total-width))))
			     "#7FFF0F" "#2A2A2A" "#EEEEEE")
		  )
		 (concat
		  (propertize "─" 'face '(:foreground "#EEEEEE"))
		  (borderize " %l %c "
			     "#0FFFDF" "#2A2A2A" "#EEEEEE")
		  (propertize "─" 'face '(:foreground "#EEEEEE"))
		  (let (git_branch (git+-branch))
		    (if git_branch
			(borderize (trim (or (git+-branch) "")
					 (truncate (* .3 (window-total-width))) 1.0 0.0)
				   "#FF38EB" "#2A2A2A" "#EEEEEE")
		      ""))
		  (propertize "─" 'face '(:foreground "#EEEEEE"))

		  (if (bound-and-true-p flymake-mode)
		   (borderize
		    (concat
		     (propertize 
		      (concat
		       (nth 1 (nth 1 (flymake--mode-line-counter :error)))
		       " ")
		      'face '(:foreground "#FC0D0D" :background "#2A2A2A" :weight bold))
		     (propertize 
		       (nth 1 (nth 1 (flymake--mode-line-counter :warning)))
		      'face '(:foreground "#FCCC0D" :background "#2A2A2A" :weight bold)
		      )
		     (if (flymake--mode-line-counter :note)
			 (propertize
			  (concat
			   " "
			   (nth 1 (nth 1 (flymake--mode-line-counter :note)))
			   )
			  'face '(:foreground "#39FF12" :background "#2A2A2A" :weight bold)
			  )
		       ""
		       )
		     )
		    nil "#1E1E1E" "#EEEEEE"
		    )
		   ""
		   )
		  )
		 (propertize "─" 'face '(:foreground "#eeeeee"))
		 )
		       )
		)
	      )


