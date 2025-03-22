{
  config,
  pkgs,
  ...
}: {
  enable = true;
  layers = {
    "c-c++" = {
      variables = {
        "c-c++-backend" = "'eglot";
        "c-c++-default-mode-for-headers" = "'c++-mode";
      };
    };
    css = {};
    dash = {};
    deft = {};
    git = {};
    go = {};
    graphviz = {};
    haskell = {};
    html = {};
    imenu-list = {};
    ivy = {};
    javascript = {};
    jsonnet = {};
    eglot = {};
    lua = {};
    markdown = {};
    "multiple-cursors" = {};
    # in emacs editing the nix config for emacs in nix configs...
    nixos = {
      variables = {
        "nix-backend" = "'eglot";
        "nixos-format-on-save" = "t";
      };
    };
    systemd = {};
    "shell-scripts" = {
      variables = {
        "shell-scripts-backend" = "'eglot";
      };
    };
    php = {};
    python = {
      variables = {
        "python-backend" = "'eglot";
      };
    };
    protobuf = {};
    rust = {};
    scala = {};
    sql = {};
    typescript = {};
    treemacs = {};
    syntax-checking = {};
    version_control = {
      variables = {
        "version-control-diff-tool" = "'diff-hl";
        "version-control_diff-side" = "'left";
        "version-control-global-margin" = "t";
      };
    };
    yaml = {};
  };
  dotspacemacs_options = {
    "editing-style" = "'emacs";
  };
  extra_packages = {
    "bazel" = {};
    "undo-tree" = {
      config = "(global-undo-tree-mode)";
    };
    "diff-hl" = {
      config = ''
        (global-diff-hl-mode)
        (diff-hl-margin-mode)
      '';
    };
    "eldoc-box" = {};
    "highlight-indent-guides" = {
      config = ''
        (setq highlight-indent-guides-suppress-auto-error t)
        (highlight-indent-guides-mode)
        (setq highlight-indent-guides-method 'character)
        (set-face-foreground 'highlight-indent-guides-character-face "#222222")
      '';
    };
    "mmm-mode" = {
      config = ''
        (require 'mmm-mode)
        (setq mmm-global-mode 'maybe)
      '';
    };
    "xclip" = {
      config = ''
        (xclip-mode 1)
      '';
    };
  };
  extra_functions = builtins.readFile ./spacemacs_extras/extra_functions.el;
  extra_els = {
    google-c-style = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/google/styleguide/8487c083e1faecb1259be8a8873618cfdb69d33d/google-c-style.el";
      sha256 = "017m6sf66zm9pq0zds8fgrmmzp3w73svg95fz04lj3wbj3r3gfbc";
    };
  };
  global_config = {
    remove_keybindings = [
      "<left>"
      "<right>"
      "<up>"
      "<down>"
      "C-<left>"
      "C-<right>"
      "C-<up>"
      "C-<down>"
      "M-;"
      "M-c"
      "C-?"
      "M-."
      "M-TAB"
      "C-i"
      "M-s"
      "M-j"
      "M-i"
      "M-o"
      "M-I"
      "M-O"
    ];
    keybindings = {
      "<down>" = "'shrink-window";
      "M-n" = "'forward-paragraph";
      "<up>" = "'enlarge-window";
      "M-p" = "'backward-paragraph";
      "<right>" = "'enlarge-window-horizontally";
      "M-f" = "'forward-to-separator";
      "<left>" = "'shrink-window-horizontally";
      "M-b" = "'backward-to-separator";
      "M-P" = "(lambda () (interactive) (previous-line 5))";
      "M-N" = "(lambda () (interactive) (next-line 5))";
      "C-h" = "'delete-backward-char";
      "M-h" = "'backward-kill-word";
      "M-j" = "'find-file-at-point";
      "C-j" = "'browse-url-at-point";
      "M-;" = "'toggle-comment-on-line";
      "M-s" = "'counsel-git-grep";
      "M-i" = "'backward-local-mark";
      "M-o" = "'forward-local-mark";
      "M-I" = "'backward-global-mark";
      "M-O" = "'forward-global-mark";
      "M-TAB" = "'eglot-format-buffer";
      "TAB" = "'eglot-format";
      "M-q" = "'fill-sentence";
      "C-?" = "'help-command";
      "C-x h" = "'eldoc";
      "C-x C-r" = "'rename-current-buffer-file";
    };
    set_variables = {
      auto-window-vscroll = "nil";
      company-idle-delay = "0.05";
      eldoc-idle-delay = "0.05";
      eldoc-echo-area-use-multiline-p = "2";
      fast-but-imprecise-scrolling = "t";
      gc-cons-threshold = "100000000";
      global-mark-ring-max = "512";
      indent-tabs-mode = "nil";
      jit-lock-defer-time = "0";
      js-indent-level = "2";
      linum-format = "\"%4d\u2502\"";
      lsp-completion-provider = ":capf";
      lsp-diagnostic-package = ":none";
      lsp-disabled-clients = "'(mspyls)";
      lsp-file-watch-threshold = "5000";
      lsp-headerline-breadcrumb-segments = "'(project file symbols)";
      lsp-idle-delay = "0.2";
      lsp-ui-sideline-enable = "nil";
      lsp-ui-doc-enable = "nil";
      lsp-ui-flycheck-enable = "nil";
      lsp-ui-imenu-enable = "t";
      lsp-ui-sideline-ignore-duplicate = "t";
      mark-ring-max = "512";
      python-indent-offset = "4";
      py-indent-offset = "4";
      save-interprogram-paste-before-kill = "t";
      separators-regexp = "\"[\\-'\\\"();:,.\\\\/?!@#%&*+= ]\"";
      show-paren-delay = "0";
      tab-width = "2";
      read-process-output-max = "(* 8192 8192)";
    };
    extra_config = ''
      (menu-bar-mode -1)
      (toggle-scroll-bar -1)
      (tool-bar-mode -1)
      (mapc 'my-mmm-markdown-auto-class
            '("awk" "bibtex" "c" "cpp" "css" "html" "latex" "lisp" "makefile"
              "markdown" "python" "r" "ruby" "sql" "stata" "xml" "php"))

      (mmm-add-classes
        '((markdown-bash
           :submode shell-script-mode
           :front "^```bash[\n\r]+"
           :back "^```$")))
    '';
  };
  modal_config = {
    python-mode = {
      set_variables = {
        # Just like to be sure I guess...
        python-indent-offset = "4";
        py-indent-offset = "4";
        tab-width = "4";
      };
    };
    js-mode = {};
    LaTeX-mode = {
      set_variables = {
        sentence-end = "\"[.!?]\"";
      };
    };
    c-mode-common = {
      keybindings = {
        "M-TAB" = "'clang-format-region";
      };
      extra_config = "google-set-c-style";
    };
    "c++-mode" = {
      extra_config = "c++-spelling-hook";
    };
  };
  custom_colors = {
    bg1 = "nil";
    bg2 = "#151515";
    base = "#22DD22";
    comment = "#FF2222";
    type = "#99FF22";
    var = "#00FFBB";
    mat = "#222222";
    lnum = "#777777";
    const = "#99CC99";
    highlight = "#222222";
    comment-bg = "#000000";
  };
}
