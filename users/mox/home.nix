{
  home.username = "mox";
  home.homeDirectory = "/home/mox";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

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
}
