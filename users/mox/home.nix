{config, pkgs, ...}: {
  home.packages = with pkgs; [
    dmenu
    feh
    firefox
    gitmux
    nerdfonts
    font-awesome
    kitty
    mplayer
    picom
    steam
    syncthing
    tmux
    xmonad-with-packages
    zathura
  ];

  home.username = "mox";
  home.homeDirectory = "/home/mox";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  # Symlink /fast/mox/... to the home directory
  # To add/remove, alter the argument attribute set
  # TODO: make this conditional on an attribute so
  # that home.nix is more portable.
  home.file = (builtins.mapAttrs
   (name: dir: {
      source =
        config.lib.file.mkOutOfStoreSymlink "/fast/mox/${dir}";
      target = "${dir}";
   }) {
      notes = "notes";
      projects = "projects";
      tools = "tools";});

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

  programs.tmux = (import ./programs/tmux.nix {config=config; pkgs=pkgs;});

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

  services.emacs.enable = true;
  services.picom = {
    enable = true;
    package = pkgs.picom;
    backend = "glx";
  };
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
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
    };
    mimeApps.associations.added = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/postscript" = "org.pwmt.zathura.desktop";
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
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
    };
  };
}
