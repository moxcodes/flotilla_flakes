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
      gsettings set $gnome_schema font-name 'inconsolata 8'
      gsettings set $gnome_schema document-font-name 'inconsolata 8'
      gsettings set $gnome_schema monospace-font-name 'inconsolata 8'
    '';
  };
  # configure-gitmux = pkgs.writeTextFile {
  #   name = "configure-gitmux";
  #   destination = "/home/mox/.gitmux"
  #   executable = false;
  #   text = 
  # };
in
{
  imports = [ ./modules/gitmux.nix ];
  home.packages = with pkgs;
  let
    diffusers = ps: ps.callPackage ./deriv/diffusers {};
    python-with-packages = python3.withPackages(ps: with ps; [
       beautifulsoup4
       google-api-python-client
       google-auth-httplib2
       google-auth-oauthlib
       numpy
       pyusb
       selenium
#      huggingface-hub torch transformers (diffusers ps)
    ]);
  in
  [
    android-tools
    awscli2
    bat
    bemenu
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
    inconsolata-nerdfont
    jq
    # TODO - try to make this a part of emacs dependencies somehow
    ispell
    file
    font-awesome
    kitty
    krita
    lutris
    mplayer
    plata-theme
    paper-gtk-theme
    slurp
    steam
    syncthing
    tmux
    texlive.combined.scheme-full
    waybar
    wl-clipboard
    xdg-utils
    xf86_input_wacom
    xmonad-with-packages
    xorg.xev
    zathura
    zoom-us
#    python3
    python-with-packages
    (callPackage ./deriv/multibg-sway { })
  ];

  home.username = "mox";
  home.homeDirectory = "/home/mox";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  gtk = {
    theme = "Plata-Noir";
    iconTheme = "Paper";
    font.name = "inconsolata";
    font.size = 7;
  };

  # Symlink /fast/mox/... to the home directory
  # To add/remove, alter the argument attribute set
  # TODO: make this conditional on an attribute so
  # that home.nix is more portable.
  # home.file = (builtins.mapAttrs
  #  (name: dir: {
  #     source =
  #       config.lib.file.mkOutOfStoreSymlink "/fast/mox/${dir}";
  #     target = "${dir}";
  #  }) {
  #     notes = "notes";
  #     projects = "projects";
  #     tools = "tools";});

  programs.git = {
    enable = true;
    userName = "Jordan Moxon";
    userEmail = "jordan@mox.codes";
    ignores = [
      "*~"
      ".*"
    ];
    delta.enable = true;
    delta.options = {
      side-by-side = true;
    };
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
      name = "inconsolata";
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

  programs.fish = {
    enable = true;
    functions = {
      mx = "emacsclient -nw $argv";
    };
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
      menu = "bemenu-run --fn \"inconsolata\" -p \"▶\" --tf \"#00FF00FF\" --tb \"#00000050\" --nf \"#00FF00\" --nb \"#00000050\" --ab \"#00000050\" --fb \"#00000050\" --ff \"#00FF00\" --hf \"#00FF00\" --hb \"#444444\" | xargs swaymsg exec";
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
