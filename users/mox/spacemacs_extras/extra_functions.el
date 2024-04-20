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
