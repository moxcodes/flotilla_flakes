{meta_conf}: {
  config,
  pkgs,
  lib,
  ...
}@args: let
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
  imports = [
    # program modules/extensions
    ./modules/python_manager.nix

    # personal config factoring
    ((import ./backend_dev_edc.nix {custom = custom; }) args)
    ((import ./matrix.nix {custom = custom; }) args)
    ((import ./shell.nix {custom = custom; }) args)    
  ];
  python_manager = with pkgs; {
    enable = true;
    python = python3;
    python_packages = [
      "google-api-python-client"
      "google-auth-httplib2"
      "google-auth-oauthlib"
      "websocket-client"
    ];
  };
  home.packages = with pkgs; [
    age
    awscli2
    alsa-utils
    bemenu
    chromedriver
    configure-gtk
    dconf
    dmenu
    dmidecode
    feh
    firefox-bin
    glxinfo
    gimp
    grim
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
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
    texlive.combined.scheme-full
    waybar
    wl-clipboard
    xdg-utils
    xf86_input_wacom
    xorg.xev
    wlr-randr
    zathura
    zoom-us
    (callPackage ./deriv/multibg-sway {})
  ];

  home.username = "mox";
  home.homeDirectory = "/home/mox";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme = {
      package = pkgs.plata-theme;
      name = "Plata-Noir";
    };
    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
    font.name = "InconsolataNerdFont";
    font.size = meta_conf.fontsize;
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
      size = meta_conf.fontsize + 0.0;
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
          "HDMI-A-1"
        ];
        modules-left = ["sway/workspaces"];
        modules-right = ["clock" "battery"];
        modules-center = [];
        "sway/workspaces" = {
          format = "{name}{icon}";
          on-click = "activate";
          format-icons = {
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = " ";
            "5" = " ⊙";
            "6" = " ";
            "7" = " ";
            "8" = " ";
            "9" = " ";
            "10" = " ";
            "11" = " ";
            "12" = " ";
            "13" = " ";
            "14" = " ⊙";
            "15" = " ";
            "16" = " ";
            "17" = " ";
            "18" = " ";
          };
        };
      };
    };
    style = ''
      * {
        font-family: InconsolataNerdFont;
        padding: 0 0;
        margin: -2 0;
        transition: all 0.0s ease;
      }

      #workspaces {
        padding: 0 4;
        margin: -2 0;
      }
      #workspaces button {
        padding: 0 0;
        margin: -2 -1;
        box-shadow: inset 0px 9px 0px 1px #008800,
                    inset 0px -9px 0px 1px #008800;
      }
      #workspacesB button.visible {
        padding: 0 0;
        margin: -2 -1;
        color: #00ff00;
        box-shadow: inset 0px 9px 0px 1px #00ff00,
                    inset 0px -9px 0px 1px #00ff00;
      }
    '';
  };

  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=127.0.0.1:8384"
      "-home=/home/mox/.config/syncthing"
    ];
  };

  xdg = {
    enable = true;
    desktopEntries = {
      emacs-nw = {
        name = "Emacs Terminal";
        genericName = "Text Editor";
        exec = "emacsclient -nw %U";
        terminal = true;
        categories = ["Application" "IDE" "TextTools"];
        mimeType = [
          "text/english"
          "text/plain"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tcl"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
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
      BLOCK=$(( ($CURRENT - 1) / ($COLUMNS * $ROWS)))
      COL=$(( ($CURRENT - 1) % $COLUMNS))
      ROW=$(( (($CURRENT - 1) / $COLUMNS) % $ROWS))
      if [[ $DIRECTION == "up" ]]; then
        ROW=$(( ($ROW - 1 + $ROWS) % $ROWS ))
      elif [[ $DIRECTION == "down" ]]; then
        ROW=$(( ($ROW + 1) % $ROWS ))
      elif [[ $DIRECTION == "left" ]]; then
        COL=$(( ($COL - 1 + $COLUMNS) % $COLUMNS ))
      else
        COL=$(( ($COL + 1) % $COLUMNS ))
      fi
      NEW=$(( $BLOCK * $ROWS * $COLUMNS + $ROW * $COLUMNS + $COL + 1))
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
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
      in
        pkgs.lib.mkOptionDefault {
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
          "${mod}+Alt+Control+Shift+Right" = "move workspace to output right";
          "${mod}+Alt+Control+Shift+Left" = "move workspace to output left";
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
        names = ["InconsolataNerdFont"];
        size = meta_conf.fontsize + 0.0;
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      output = {
        "eDP-1" = {
          bg = "~/.config/sway/wallpapers/eDP-1/_default.png fill";
          pos = "0 0";
          res = "1920x1080";
          scale = "1.0";
        };
      };
      terminal = "kitty";
      startup = [];
    };
    checkConfig = false;
    extraConfig = ''
      output HDMI-A-1 mode 2560x1440 pos 1920 0 scale 1
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

