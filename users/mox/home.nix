{config, pkgs, ...}:
let
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Plata-Noir'
      gsettings set $gnome_schema icon-theme 'Paper'
      gsettings set $gnome_schema font-name 'InconsolataNerdFont 8'
      gsettings set $gnome_schema document-font-name 'InconsolataNerdFont 8'
      gsettings set $gnome_schema monospace-font-name 'InconsolataNerdFont 8'
    '';
  };
in
{
  imports = [ ./modules/gitmux.nix ./modules/spacemacs.nix ./modules/python_manager.nix];
  python_manager =  with pkgs; {
    enable = true;
    python = python3;
    python_packages = [
      "beautifulsoup4"
      "google-api-python-client"
      "google-auth-httplib2"
      "google-auth-oauthlib"
      "numpy"
      "pyusb"
      "selenium"
      "websocket-client"
    ];
  };
  home.packages = with pkgs;
  [
    age
    android-tools
    awscli2
    alsa-utils
    bat
    bemenu
    browsh
    chromedriver
    configure-gtk
    dmenu
    dmidecode
    fd
    feh
    fzf
    firefox-bin
    glxinfo
    gimp
    gitmux
    gnumake
    grim
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
    jq
    # TODO - try to make this a part of emacs dependencies somehow
    ispell
    file
    font-awesome
    kitty
    krita
    lutris
    mplayer
    obsidian
    plata-theme
    paper-gtk-theme
    silver-searcher
    slurp
    sops
    steam
    syncthing
    tmux
    texlive.combined.scheme-full
    waybar
    wl-clipboard
    xdg-utils
    xf86_input_wacom
    xorg.xev
    zathura
    zoom-us
    (callPackage ./deriv/multibg-sway { })
  ];

  home.username = "mox";
  home.homeDirectory = "/home/mox";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  gtk = {
    theme = "Plata-Noir";
    iconTheme = "Paper";
    font.name = "InconsolataNerdFont";
    font.size = 7;
  };

  programs.git = {
    enable = true;
    userName = "Jordan Moxon";
    userEmail = "jordan@mox.codes";
    ignores = [
      "*~"
      ".*"
    ];
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.emacs = {
    enable = true;
  };

  # programs.firefox = {
  #   profiles.mox = {
  # site: https://addons.mozilla.org/firefox/downloads/latest/<number>
  # bitwarden: 735894
  # ublock origin: 607454
  #   };
  # };

  programs.kitty = {
    enable = true;
    font = {
      name = "InconsolataNerdFont";
      size = 8.0;
    };
    settings = {
      cursor = "#00DD00";
      scrollback_lines = 5000;
      repaint_delay = 5;
      input_delay = 0;
      sync_to_monitor = "yes";
      enable_audio_bell = "no";
      window_border_width = "0.0";
      draw_minimal_borders = "yes";
      window_margin_width = "0.0";
      window_padding_width = 0;
      background_opacity = "0.7";
      dynamic_background_opacity = "no";
      foreground = "#00dd00";
    };
    extraConfig = ''
    symbol_map U+E0A0-U+E0A3,U+E0C0-U+E0C7 PowerlineSymbols
    symbol_map U+23FB-U+2B58,U+E000-U+EBFF,U+F000-U+FD46,U+F0000-U+F0FFF SymbolsNF
    map kitty_mod+equal change_font_size all +1.0
    map kitty_mod+minus change_font_size all -1.0
    '';
  };

  programs.tmux = (import ./programs/tmux.nix {config=config; pkgs=pkgs;});
  programs.gitmux = {
    enable = true;
    styles.clear = "#[fg=white]";
    symbols = {
      branch = " ";
      hashprefix = "#";
      ahead = "󰶼";
      behind = "󰶹";
      staged = "󱒌 ";
      conflict = " ";
      modified = " ";
      untracked = " ";
      stashed = "󰽃 ";
      insertions = "+";
      deletions = "-";
      clean = " ";
    };
    layout = ''[branch, " ▏", divergence, " ▏", flags, " ▏", stats ]'';
  };
  programs.spacemacs = {
    enable = true;
    layers = {
      "c-c++" = {
        variables = {
          "c-c++-backend" = "'lsp-ccls";
          "c-c++-default-mode-for-headers" = "'c++-mode";
        };
      };
      dash = {};
      deft = {};
      git = {};
      graphviz = {};
      haskell = {};
      html = {};
      imenu-list = {};
      ivy = {};
      javascript = {};
      lsp = {};
      lua = {};
      markdown = {};
      "multiple-cursors" = {};
      # in emacs editing the nix config for emacs in nix configs...
      nixos = {
        variables = {
          "nix-backend" = "'lsp";
          "nixos-format-on-save" = "t";
        };
      };
      systemd = {};
      "shell-scripts" = {
        variables = {
          "shell-scripts-backend" = "'lsp";
        };
      };
      php = {};
      python = {
        variables = {
          "python-lsp-server" = "'pylsp";
        };
      };
      rust = {};
      sql = {};
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
      "undo-tree" = {
        config = "(global-undo-tree-mode)";
      };
      "diff-hl" = {
        config = ''
          (global-diff-hl-mode)
          (diff-hl-margin-mode)
        '';
      };
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
    extra_functions = (builtins.readFile ./spacemacs_extras/extra_functions.el);
    extra_els = {
      google-c-style = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/google/styleguide/8487c083e1faecb1259be8a8873618cfdb69d33d/google-c-style.el";
        sha256 = "017m6sf66zm9pq0zds8fgrmmzp3w73svg95fz04lj3wbj3r3gfbc";
      };
    };
    global_config = {
      remove_keybindings = ["M-]" "M-[" "<left>" "<right>" "<up>" "<down>"
                            "C-<left>" "C-<right>" "C-<up>" "C-<down>" "M-;" "M-c"
                            "C-?" "M-." "M-TAB" "C-i" "M-s"];
      keybindings = {
        "M-n" = "'forward-paragraph";
        "M-p" = "'backward-paragraph";
        "M-f" = "'forward-to-separator";
        "M-b" = "'backward-to-separator";
        "M-P" = "(lambda () (interactive) (previous-line 5))";
        "M-N" = "(lambda () (interactive) (next-line 5))";
        "C-h" = "'delete-backward-char";
        "M-h" = "'backward-kill-word";
        "M-;" = "'toggle-comment-on-line";
        "M-." = "'lsp-find-definition";
        "M-s" = "'counsel-git-grep";
        "M-[" = "'backward-local-mark";
        "M-]" = "'forward-local-mark";
        "M-{" = "'backward-global-mark";
        "M-}" = "'forward-global-mark";
        "M-TAB" = "'lsp-format-region";
        "M-q" = "'fill-sentence";
        "C-?" = "'help-command";
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
  };

  programs.fish = {
    enable = true;
    functions = {
      mx = "emacsclient -nw $argv";
    };
    shellInit = ''
set -g EDITOR "emacsclient -nw"
set -U fish_greeting ""
# handy function from projekt0n/biscuit
set right_segment_separator "▕"
set left_segment_separator "▏"
function prompt_segment -d "Function to draw a segment"
  set -l bg
  set -l fg
  if [ -n "$argv[2]" ]
    set bg $argv[2]
  else
    set bg normal
  end
  if [ -n "$argv[3]" ]
    set fg $argv[3]
  else
    set fg normal
  end

  set -l sep_col (set_color $argv[1] -b $bg)
  set -l txt_col (set_color -o $fg -b $bg)
  set -l normal (set_color normal)

  set -l lsep $sep_col $left_segment_separator
  set -l rsep $sep_col $right_segment_separator

  if [ -n "$argv[4]" ]
    set -l data  $txt_col $argv[4] $normal
    echo -n -s $lsep $data $rsep
  end
  set_color normal -b normal
end
function fish_prompt
  set -l this_status $status
  set -l color white
  if test $this_status -eq 1
    set color ff31aa
  else if test $this_status -ge 126 && test $this_status -le 127
    set color ff8700
  else if test $this_status -eq 130
    set color ffec00
  else if test $this_status -ge 128
    set color cc00ff
  else if test $this_status -ge 1
    set color ff0000
  else
    set color white
  end
  prompt_segment $color 222 green (prompt_hostname)
  echo -n " "
  prompt_segment $color 222 cyan (date '+%H:%M:%S')
  echo -n " "
end
function fish_right_prompt
  set -l this_status $status
  set -l color white
  if test $this_status -eq 1
    set color ff31aa
  else if test $this_status -ge 126 && test $this_status -le 127
    set color ff8700
  else if test $this_status -eq 130
    set color ffec00
  else if test $this_status -ge 128
    set color cc00ff
  else if test $this_status -ge 1
    set color ff0000
  else
    set color white
  end
  prompt_segment $color 222 red (prompt_pwd)
end
  set_color
    '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "e5d54b93cd3e096ad6c2a419df33c4f50451c900";
          sha256 = "5cO5Ey7z7KMF3vqQhIbYip5JR6YiS2I9VPRd6BOmeC8=";
        };
      }
    ];
  };

  programs.zathura = {
    enable = true;
    mappings = {
      # basic emacs-style navigation
      "<C-p>" = "scroll up";
      "<C-n>" = "scroll down";

      "<A-p>" = "navigate previous";
      "<A-n>" = "navigate next";

      "[index] <C-p>" = "navigate_index up";
      "[index] <C-n>" = "navigate_index down";
      "[index] <C-f>" = "navigate_index expand";
      "[index] <C-b>" = "navigate_index collapse";

      "<C-l>" = "snap_to_page";

      # can't make it work like C-s also initiates the search. That has to
      # remain '/'
      "<C-s>" = "search forward";
      "<C-r>" = "search backward";

      "<C-,>" = "toggle_statusbar";
      "xp" = "print";

      # Some 'clever' tweaking to emulate a 'section jumping' feature P/N for
      # forward/back at the current level F/B for expanding and collapsing
      # without keeping the index up
      "<A-P>" = "feedkeys <Tab><Up><Return>";
      "<A-N>" = "feedkeys <Tab><Down><Return>";
      "<A-F>" = "feedkeys <Tab><Right><Return>";
      "<A-B>" = "feedkeys <Tab><Left><Return>";

      # I don't think we can parse C-x C-f here, so this will have to do
      "xf" = "feedkeys :open\ <Tab>";
    };
    options = {
      # copy to clipboard, rather than middle mouse click
      selection-clipboard = "clipboard";

      completion-bg = "#000000";
      completion-fg = "#00DD00";
      completion-highlight-bg = "#232323";
      completion-highlight-fg = "#00DD00";

      inputbar-bg = "#000000";
      inputbar-fg = "#00DD00";
      statusbar-bg = "#000000";
      statusbar-fg = "#00DD00";

      index-bg = "#000000";
      index-fg = "#00DD00";
      index-active-bg = "#232323";
      index-active-fg = "#00DD00";
      page-padding = 1;
      page-cache-size = 500;
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 10;
        output = [
          "eDP-1"
        ];
      };
    };
  };

  services.emacs.enable = true;
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=127.0.0.1:8384"
      "-home=/home/mox/.config/syncthing"
    ];
  };

  # because the auto-generated service for tmux-continuum isn't good enough to
  # handle the nix symlink jungle... and is borked in other ways too...
  systemd.user.services = {
    tmux_continuum = {
      Unit = {
        Description = "tmux default session (detached)";
        Documentation = [ "man:tmux(1)" ];
        # lists are duplicate keys
        After = [ "emacs.service" "syncthing.service" ];
      };
      Service = {
        ExecStart="${pkgs.tmux.outPath}/bin/tmux new-session -d ${pkgs.tmux.outPath}/bin/tmux run-shell ${pkgs.tmuxPlugins.resurrect.outPath}/share/tmux-plugins/resurrect/scripts/restore.sh";
        ExecStop="${pkgs.tmux.outPath}/bin/tmux run-shell ${pkgs.tmuxPlugins.resurrect.outPath}/share/tmux-plugins/resurrect/scripts/save.sh";
        Restart="on-failure";
        RestartSec="5";
        StartLimitBurst="5";
        StartLimitIntervalSec="10";
        SuccessExitStatus="15";
        Type="forking";
      };
      Install.WantedBy=[ "default.target" ];
    };
  };

  xdg = {
    enable = true;
    desktopEntries = {
      emacs-nw = {
        name = "Emacs Terminal";
        genericName = "Text Editor";
        exec = "emacsclient -nw %U";
        terminal = true;
        categories = [ "Application" "IDE" "TextTools" ];
        mimeType = [ "text/english" "text/plain" "text/x-makefile"
                     "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc"
                     "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl"
                     "text/x-tex" "application/x-shellscript" "text/x-c"
                     "text/x-c++"];
      };
    };
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/ogg" = "mplayer.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/postscript" = "org.pwmt.zathura.desktop";
      "application/x-shellscript" = "emacs-nw.desktop";
      "image/bmp" = "feh.desktop";
      "image/vnd.djvu" = "org.pwmt.zathura.desktop";
      "image/jpeg" = "feh.desktop";
      "text/english" = "emacs-nw.desktop";
      "text/plain" = "emacs-nw.desktop";
      "text/x-asm" = "emacs-nw.desktop";
      "text/x-makefile" = "emacs-nw.desktop";
      "text/x-c++hdr" = "emacs-nw.desktop";
      "text/x-c++src" = "emacs-nw.desktop";
      "text/x-chdr" = "emacs-nw.desktop";
      "text/x-csrc" = "emacs-nw.desktop";
      "text/x-java" = "emacs-nw.desktop";
      "text/x-moc" = "emacs-nw.desktop";
      "text/x-pascal" = "emacs-nw.desktop";
      "text/x-tcl" = "emacs-nw.desktop";
      "text/x-tex" = "emacs-nw.desktop";
      "text/x-c" = "emacs-nw.desktop";
      "text/x-c++" = "emacs-nw.desktop";
      "video/mp4" = "mplayer.desktop";
      "video/mpeg" = "mplayer.desktop";
      "video/ogg" = "mplayer.desktop";
      "video/x-msvideo" = "mplayer.desktop";
      "video/x-ms-wm" = "mplayer.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
    };
  };
  
  wayland.windowManager.sway = let
    workspaceSwitchScript = pkgs.writeShellScript "workspace_switch.bash" ''
      ROWS=3
      COLUMNS=3
      # don't move by default
      MOVE_WINDOW=False
      DIRECTION=""
      while getopts ":r::c::d::m" opt; do
        case $opt in
           r)
             ROWS=$OPTARG
             ;;
           c)
             COLUMNS=$OPTARG
             ;;
           d)
             DIRECTION=$OPTARG
             ;;
           m)
             MOVE_WINDOW=True
             ;;
           *)
             echo "invalid command: no parameter included with argument $OPTARG"
             ;;
        esac
      done
      CURRENT=`${pkgs.sway.outPath}/bin/swaymsg -t get_workspaces | ${pkgs.jq.outPath}/bin/jq '.[] | select(.focused==true) | .num'`
      COL=$(( ($CURRENT - 1) % $COLUMNS))
      ROW=$(( ($CURRENT - 1) / $COLUMNS))
      if [[ $DIRECTION == "up" ]]; then
        ROW=$(( ($ROW - 1 + $ROWS) % $ROWS ))
      elif [[ $DIRECTION == "down" ]]; then
        ROW=$(( ($ROW + 1) % $ROWS ))
      elif [[ $DIRECTION == "left" ]]; then
        COL=$(( ($COL - 1 + $COLUMNS) % $COLUMNS ))
      else
        COL=$(( ($COL + 1) % $COLUMNS ))
      fi
      NEW=$(( $ROW * $COLUMNS + $COL + 1))
      if [[ $MOVE_WINDOW == True ]]; then
        ${pkgs.sway.outPath}/bin/swaymsg move container to workspace $NEW
      fi
      ${pkgs.sway.outPath}/bin/swaymsg workspace $NEW
    '';
  in {
    enable = true;
    config = rec {
      menu = "bemenu-run --fn \"InconsolataNerdFont\" -p \"▶\" --tf \"#00FF00FF\" --tb \"#00000050\" --nf \"#00FF00\" --nb \"#00000050\" --ab \"#00000050\" --fb \"#00000050\" --ff \"#00FF00\" --hf \"#00FF00\" --hb \"#444444\" | xargs swaymsg exec";
      modifier = "Mod4";
      output.eDP-1 = {
        bg = "~/.config/sway/wallpapers/eDP-1/_default.png fill";
      };
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
      in pkgs.lib.mkOptionDefault {
        "${mod}+Up" = "focus up";
        "${mod}+Down" = "focus down";
        "${mod}+Left" = "focus left";
        "${mod}+Right" = "focus right";
        "${mod}+Tab" = "focus parent";
        "${mod}+Shift+Tab" = "focus child";

        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Right" = "move right";

        "${mod}+bar" = "split horizontal";
        "${mod}+minus" = "split vertical";

        "${mod}+Shift+c" = "kill";

        "${mod}+Control+Left" = "resize shrink width 20 px";
        "${mod}+Control+Right" = "resize grow width 20 px";
        "${mod}+Control+Up" = "resize grow height 20 px";
        "${mod}+Control+Down" = "resize shrink height 20 px";
        
        "XF86MonBrightnessUp" = "exec light -A 1";
        "XF86MonBrightnessDown" = "exec light -U 1";
        
        "${mod}+Alt+Up" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -d up";
        "${mod}+Alt+Down" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -d down";
        "${mod}+Alt+Left" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -d left";
        "${mod}+Alt+Right" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -d right";

        "${mod}+Alt+Shift+Up" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -m -d up";
        "${mod}+Alt+Shift+Down" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -m -d down";
        "${mod}+Alt+Shift+Left" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -m -d left";
        "${mod}+Alt+Shift+Right" = "exec ${pkgs.bash.outPath}/bin/bash ${workspaceSwitchScript} -m -d right";
      };
      window.border = 1;
      colors = {
        background = "#000000";
        focused = {
          background = "#000000";
          border = "#00cc00";
          childBorder = "#00cc00";
          indicator = "#ffffff";
          text = "#00ff00";
        };
        unfocused = {
          background = "#000000";
          border = "#005000";
          childBorder = "#005000";
          indicator = "#ffffff";
          text = "#00ff00";
        };
        focusedInactive = {
          background = "#000000";
          border = "#005000";
          childBorder = "#005000";
          indicator = "#ffffff";
          text = "#00ff00";
        };
        urgent = {
          background = "#000000";
          border = "#ff0000";
          childBorder = "#ff0000";
          indicator = "#ffffff";
          text = "#00ff00";
        };
      };
      fonts = {
        names = [ "inconsolata" ];
        size = 8.0;
      };
      bars = [
      #  {
      #   command = "${pkgs.waybar.outPath}/bin/waybar";
      # }
       ];
      terminal = "kitty";
      startup = [];
    };
    extraConfig = ''
      input type:keyboard {
        repeat_delay 200
        repeat_rate 30
      }

      exec configure-gtk
    '';
  };
  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = 1;
  };
}
