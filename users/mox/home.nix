{config, pkgs, ...}: {
  home.packages = with pkgs; [
    dmenu
    feh
    firefox
    kitty
    mplayer
    steam
    syncthing
    tmux
    xcompmgr
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
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=127.0.0.1:8384"
      "-home=/home/mox/.config/syncthing"
    ];
  };

}
