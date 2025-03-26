;; custom theme definition

(deftheme mox
  "prioritize green-on-black phosphor look, transparent bg, high contrast")

(let ((mox-bg1 nil)
      (mox-bg2 "#151515")
      (mox-base "#22DD22")
      (mox-builtin "#faec50")
      (mox-keyword "#5294ff")
      (mox-comment "#ff3333")
      (mox-string "#419e7c")
      (mox-type "#baff26")
      (mox-var "#00FFBB")
      (mox-mat "#222222")
      (mox-lnum "#424242")
      (mox-const "#a5d4a5")
      (mox-function"#f151fc")
      (mox-warning "#f5abab")
      (mox-line-highlight "#1A1A1A")
      (mox-region-highlight "#444444")
      (mox-region-highlight-fg "#44FF44")
      )
  (custom-theme-set-faces
   'mox

   ;; ---------------- Frame ---------------------------
   `(default ((t (:background ,mox-bg1 :foreground ,mox-base))))
   `(cursor  ((t (:background ,mox-base :foreground ,mox-bg2))))
   `(hl-line ((t (:background ,mox-line-highlight))))
   `(modeline ((t (:background ,mox-bg1 :foreground ,mox-base))))
   `(mode-line-inactive ((t (:box nil :background ,mox-line-highlight :foreground ,mox-type))))
   `(mode-line ((t (:box nil :foreground ,mox-base :background ,mox-bg1))))
   `(fringe ((t (:background ,mox-line-highlight))))
   ;; Dir-ed search prompt
   `(minibuffer-prompt ((default (:foreground ,mox-function))))
   ;; Highlight region color
   `(region ((t (:background ,mox-region-highlight :bold t))))

   ;; ---------------- Code Highlighting ---------------
   ;; Builtin
   `(font-lock-builtin-face ((t (:foreground ,mox-builtin))))
   ;; Comments
   `(font-lock-comment-face ((t (:foreground ,mox-comment))))
   ;; Function names
   `(font-lock-function-name-face ((t (:foreground ,mox-function))))
   ;; Keywords
   `(font-lock-keyword-face ((t (:foreground ,mox-keyword))))
   ;; Strings
   `(font-lock-string-face ((t (:foreground ,mox-string))))
   ;; Variables
   `(font-lock-variable-name-face ((t (:foreground ,mox-var))))
   `(font-lock-type-face ((t (:foreground ,mox-type))))
   `(font-lock-warning-face ((t (:foreground ,mox-warning :bold t))))
  ))

(provide-theme 'mox)
