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

  services.emacs.enable = true;
  services.syncthing = {
    enable = true;
    extraOptions = [
      "-gui-address=127.0.0.1:8384"
      "-home=/home/mox/.config/syncthing"
    ];
  };

}
