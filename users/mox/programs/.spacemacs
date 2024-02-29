;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs-base

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(systemd
     shell-scripts
;;     systemd
     graphviz
     sql
     rust
     deft
     lua
     html
     haskell
     yaml
     python
     javascript
     markdown
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; auto-completion
     ;; better-defaults
     syntax-checking
     emacs-lisp
     lsp
     (c-c++ :variables c-c++-backend 'lsp-ccls
            ccls-executable "/usr/bin/ccls"
            c-c++-default-mode-for-headers 'c++-mode
            c-c++-lsp-enable-semantic-highlight 'rainbow
            c-c++-lsp-semantic-highlight-method 'overlay)
     git
     (version-control :variables
                      version-control-diff-tool 'diff-hl
                      version-control-diff-side 'left
                      version-control-global-margin t)
     ;; helm
     ivy
     imenu-list
     ;; markdown
     multiple-cursors
     dash
     ;; org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     ;; syntax-checking
     ;; version-control
     treemacs)


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(use-package undo-tree diff-hl
                                       highlight-indent-guides)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'emacs

   dotspacemacs-verbose-loading nil

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner nil

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Source Code Pro"
                               :size 10.0
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers t

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Show trailing whitespace (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfer with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))


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

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
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
  ;; (add-hook 'c++-mode-hook
    ;; (local-set-key (kbd "M-[") "<>"))

  ;; (sp-with-modes '(c-mode c++-mode)
    ;; (sp-local-pair "<" ">"  :wrap "M-]" :actions '(wrap)))
  ;; (setq sp-escape-quotes-after-insert nil)
  ;; (setq sp-escape-wrapped-region nil)

  ;; (define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
  ;; (define-key swiper-map [escape] 'minibuffer-keyboard-quit)


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

  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (global-undo-tree-mode)
  (global-diff-hl-mode)
  (diff-hl-margin-mode)
  (global-eldoc-mode -1)


  ;; (define-key company-active-map (kbd "C-n") nil)
  ;; (define-key company-active-map (kbd "C-p") nil)
  ;; (define-key company-search-map (kbd "C-n") nil)
  ;; (define-key company-search-map (kbd "C-p") nil)

  (setq ccls-sem-highlight-method 'font-lock)

  (setq highlight-indent-guides-method 'character)
  ;; (setq highlight-indent-guides-character ?:)
  (highlight-indent-guides-mode)
  ;; (set-face-background 'highlight-indent-guides-odd-face "darkgray")
  ;; (set-face-background 'highlight-indent-guides-even-face "dimgray")
  (set-face-foreground 'highlight-indent-guides-character-face "#222222")

  ;; (define-key company-active-map (kbd "M-n") 'company-select-next)
  ;; (define-key company-active-map (kbd "M-p") 'company-select-previous)
  ;; (define-key company-search-map (kbd "M-n") 'company-select-next)
  ;; (define-key company-search-map (kbd "M-p") 'company-select-previous)

  ;; caller hierarchy. Requires LSP mode to be active
  (add-hook 'c++-mode-hook
            (local-set-key (kbd "M-]")
                           '(lambda () (interactive) (ccls-call-hierarchy nil))))

  ;; callee hierarchy. Requires LSP mode to be active
  (add-hook 'c++-mode-hook
            (local-set-key (kbd "M-]")
                           '(lambda () (interactive) (ccls-call-hierarchy t))))

  ;; inheritance hierarchy base
  (add-hook 'c++-mode-hook
            (local-set-key (kbd "M-}")
                           (lambda () (interactive) (ccls-inheritance-hierarchy nil))))

  ;; inheritance hierarchy derived
  (add-hook 'c++-mode-hook
            (local-set-key (kbd "M-}")
                           (lambda () (interactive) (ccls-inheritance-hierarchy t))))
  ;; (lsp-deferred)

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
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(journalctl-mode dash php-mode yasnippet-snippets yapfify yaml-mode which-key wgrep web-mode web-beautify use-package undo-tree treemacs-projectile treemacs-magit treemacs-icons-dired toml-mode tagedit systemd sql-indent sphinx-doc smex smeargle slim-mode scss-mode sass-mode ron-mode racer pytest pyenv-mode py-isort pug-mode prettier-js poetry pippel pipenv pip-requirements pcre2el overseer nodejs-repl nameless mmm-mode markdown-toc magit-svn magit-gitflow macrostep lsp-ui lsp-treemacs lsp-python-ms lsp-pyright lsp-origami lsp-ivy lsp-haskell livid-mode live-py-mode json-reformat json-navigator json-mode js2-refactor js-doc ivy-yasnippet ivy-xref ivy-rtags ivy-hydra ivy-avy insert-shebang importmagic impatient-mode imenu-list hybrid-mode hlint-refactor hindent highlight-indent-guides helm-make haskell-snippets graphviz-dot-mode google-c-style gitignore-templates git-timemachine git-messenger git-link gh-md fuzzy forge flycheck-ycmd flycheck-rust flycheck-rtags flycheck-pos-tip flycheck-package flycheck-haskell flycheck-elsa flycheck-bashate flx fish-mode evil-mc emr emmet-mode elisp-slime-nav dotenv-mode disaster diminish diff-hl deft dante cython-mode cpp-auto-include counsel-css company-ycmd company-web company-shell company-rtags company-lua company-cabal company-c-headers company-anaconda cmm-mode ccls cargo browse-at-remote blacken bind-map auto-yasnippet auto-compile attrap async ac-ispell))
 '(py-indent-offset 2 t)
 '(spacemacs-theme-custom-colors
   '((bg1)
     (bg2 . "#151515")
     (base . "#22DD22")
     (comment . "#FF2222")
     (type . "#99FF22")
     (var . "#00FFBB")
     (mat . "#222222")
     (lnum . "#777777")
     (const . "#99CC99")
     (highlight . "#222222")
     (comment-bg . "#000000")))
 '(tab-width 2)
 '(warning-suppress-log-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)