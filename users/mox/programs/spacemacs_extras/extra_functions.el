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
