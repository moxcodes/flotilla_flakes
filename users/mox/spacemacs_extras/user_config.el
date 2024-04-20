  (global-undo-tree-mode)
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  (global-eldoc-mode -1)

  (setq highlight-indent-guides-method 'character)
  ;; (setq highlight-indent-guides-character ?:)
  (highlight-indent-guides-mode)
  (set-face-foreground 'highlight-indent-guides-character-face "#222222")

  ;; Javascript configuration
  (add-hook 'js-mode-hook #'lsp)
  (setq js-indent-level 2)

  ;; Python configuration
  (setq lsp-disabled-clients '(mspyls))
  (setq tab-width 2)
  (setq-default python-indent-offset 4)
  (setq-default py-indent-offset 4)
  (add-hook 'python-mode-hook '(lambda ()
                                 (setq python-indent-offset 4)
                                 (setq py-indent-offset 4)
                                 (setq tab-width 4)))

(use-package lsp-pyright
    :ensure t
    :hook (python-mode . (lambda ()
                           (require 'lsp-pyright)
                           (lsp))))  ; or lsp-deferred
