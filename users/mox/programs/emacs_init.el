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

(defun eldoc-fancy (arg)
  "`eldoc' but uses the echo area by default and a prefix will swap to a buffer."
  (interactive "P")
  (let ((eldoc-display-functions
         (if arg '(eldoc-display-in-buffer) '(eldoc-display-in-echo-area))))
    (eldoc t)))

;; packages - preamble

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



;; keybindings
(global-unset-key (kbd "C-<left>"))
(global-unset-key (kbd "C-<right>"))
(global-unset-key (kbd "C-<up>"))
(global-unset-key (kbd "C-<down>"))
(global-unset-key (kbd "M-;"))
(global-unset-key (kbd "M-c"))
(global-unset-key (kbd "C-?"))
(global-unset-key (kbd "M-."))
(global-unset-key (kbd "M-TAB"))
(global-unset-key (kbd "C-i"))
(global-unset-key (kbd "M-s"))
(global-unset-key (kbd "M-j"))
(global-unset-key (kbd "M-i"))
(global-unset-key (kbd "M-o"))
(global-unset-key (kbd "M-I"))
(global-unset-key (kbd "M-O"))

(global-set-key (kbd "<down>") 'shrink-window)
(global-set-key (kbd "<left>") 'shrink-window-horizontally)
(global-set-key (kbd "<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "<up>") 'enlarge-window)
(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-j") 'browse-url-at-point)
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)
(global-set-key (kbd "C-x h") 'eldoc)
(global-set-key (kbd "M-;") 'toggle-comment-on-line)
(global-set-key (kbd "M-I") 'backward-global-mark)
(global-set-key (kbd "M-N") (lambda () (interactive) (next-line 5)))
(global-set-key (kbd "M-O") 'forward-global-mark)
(global-set-key (kbd "M-P") (lambda () (interactive) (previous-line 5)))
(global-set-key (kbd "M-TAB") 'eglot-format-buffer)
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
(global-set-key (kbd "TAB") 'eglot-format)
