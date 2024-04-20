  (custom-set-variables '(spacemacs-theme-custom-colors
                          '((bg1 . nil)
                            (bg2 . "#151515")
                            (base . "#22DD22")
                            (comment . "#FF2222")
                            (type . "#99FF22")
                            (var . "#00FFBB")
                            (mat . "#222222")
                            (lnum . "#777777")
                            (const . "#99CC99")
                            (highlight . "#222222")
                            (comment-bg . "#000000"))))

  (add-to-list 'auto-mode-alist '("\\.ci\\'" . c++-mode))
  (add-to-list 'auto-mode-alist '("\\.C\\'" . c++-mode))
  (add-to-list 'load-path "/usr/lib/llvm/12/share/clang")
  (add-to-list 'load-path "/home/mox/.local/bin")

  (global-unset-key (kbd "M-]"))
  (global-unset-key (kbd "M-["))
  (setq linum-format "%4d\u2502")
  (setq separators-regexp "[\-'\"();:,.\\/?!@#%&*+= ]")
  (global-set-key (kbd "M-n") 'forward-paragraph)
  (global-set-key (kbd "M-p") 'backward-paragraph)
  (global-set-key (kbd "M-f") 'forward-to-separator)
  (global-set-key (kbd "M-b") 'backward-to-separator)

  (global-set-key (kbd "M-s f") 'forward-to-separator-select)
  (global-set-key (kbd "M-s b") 'backward-to-separator-select)

  (global-set-key (kbd "M-P")
                  (lambda () (interactive) (previous-line 5)))
  (global-set-key (kbd "M-N")
                  (lambda () (interactive) (next-line 5)))



  (global-unset-key (kbd "<left>"))
  (global-unset-key (kbd "<right>"))
  (global-unset-key (kbd "<up>"))
  (global-unset-key (kbd "<down>"))

  (global-unset-key (kbd "C-<left>"))
  (global-unset-key (kbd "C-<right>"))
  (global-unset-key (kbd "C-<up>"))
  (global-unset-key (kbd "C-<down>"))

  (global-set-key (kbd "C-h") 'delete-backward-char)
  (global-set-key (kbd "M-h") 'backward-kill-word)

  (global-unset-key (kbd "M-c"))
  (global-set-key (kbd "M-c") 'toggle-comment-on-line)

  (global-set-key (kbd "M-q") 'fill-sentence)


  (require 'mmm-mode)
  (require z'php-mode)
  (setq mmm-global-mode 'maybe)
  (defun my-mmm-markdown-auto-class (lang &optional submode)
    "Define a mmm-mode class for LANG in `markdown-mode' using SUBMODE.
If SUBMODE is not provided, use `LANG-mode' by default."
    (let ((class (intern (concat "markdown-" lang)))
          (submode (or submode (intern (concat lang "-mode"))))
          (front (concat "^```" lang "[\n\r]+"))
          (back "^```"))
      (mmm-add-classes (list (list class :submode submode :front front :back back)))
      (mmm-add-mode-ext-class 'markdown-mode nil class)))

  ;; Mode names that derive directly from the language name
  (mapc 'my-mmm-markdown-auto-class
        '("awk" "bibtex" "c" "cpp" "css" "html" "latex" "lisp" "makefile"
          "markdown" "python" "r" "ruby" "sql" "stata" "xml" "php"))

  (mmm-add-classes
   '((markdown-bash
      :submode shell-script-mode
      :front "^```bash[\n\r]+"
      :back "^```$")))


  (setq-default indent-tabs-mode nil)

  (setq show-paren-delay 0)
  (setq eldoc-idle-delay 0.05)
  (setq company-idle-delay 0.05)

  (require 'google-c-style)
  (add-hook 'c-mode-common-hook 'google-set-c-style)

  (require 'clang-format)
  (eval-after-load "cc-mode"
    '(define-key c-mode-base-map (kbd "TAB") 'clang-format-region)
    )

  (add-hook 'LaTeX-mode-hook
            (setq sentence-end "[.!?]"))

  (menu-bar-mode -1)
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)
  (add-hook 'c++-mode-hook 'c++-spelling-hook)
  (setq lsp-file-watch-threshold 5000)

  (add-hook 'c++-mode-hook
    (local-unset-key (kbd "C-?")))
  (global-set-key (kbd "C-?") 'help-command)

  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable nil
        lsp-ui-flycheck-enable nil
        lsp-ui-imenu-enable t
        lsp-ui-sideline-ignore-duplicate t
        lsp-idle-delay 0.2
        lsp-diagnostic-package :none
        lsp-headerline-breadcrumb-segments '(project file symbols))

  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 8192 8192)) ;; 1mb
  (setq lsp-completion-provider :capf)

  (setq jit-lock-defer-time 0)
  (setq fast-but-imprecise-scrolling t)
  (setq auto-window-vscroll nil)
