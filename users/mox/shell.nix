{custom}: {
  config,
  pkgs,
  ...
}: {
  imports = [
    # program modules/extensions
    ./modules/gitmux.nix
    ./modules/spacemacs.nix
  ];
  home.packages = with pkgs; [
    bat
    browsh
    fd
    figlet
    fish
    fzf
    git
    gitmux
    gnumake
    nerd-fonts.inconsolata
    nerd-fonts.symbols-only
    jq
    # TODO - try to make this a part of emacs dependencies somehow
    ispell
    file
    font-awesome
    ripgrep
    silver-searcher
    tmux
    yq
  ];
  programs.git = {
    enable = true;
    userName = "Jordan Moxon";
    userEmail = custom.email;
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
  services.emacs.enable = true;

  programs.tmux = import ./programs/tmux.nix {
    config = config;
    pkgs = pkgs;
  };

  # because the auto-generated service for tmux-continuum isn't good enough to
  # handle the nix symlink jungle... and is borked in other ways too...
  systemd.user.services = {
    tmux_continuum = {
      Unit = {
        Description = "tmux default session (detached)";
        Documentation = ["man:tmux(1)"];
        # lists are duplicate keys
        After = ["emacs.service" "syncthing.service"];
      };
      Service = {
        ExecStart = "${pkgs.tmux.outPath}/bin/tmux new-session -d ${pkgs.tmux.outPath}/bin/tmux run-shell ${pkgs.tmuxPlugins.resurrect.outPath}/share/tmux-plugins/resurrect/scripts/restore.sh";
        ExecStop = "${pkgs.tmux.outPath}/bin/tmux run-shell ${pkgs.tmuxPlugins.resurrect.outPath}/share/tmux-plugins/resurrect/scripts/save.sh";
        Restart = "on-failure";
        RestartSec = "5";
        StartLimitBurst = "5";
        StartLimitIntervalSec = "10";
        SuccessExitStatus = "15";
        Type = "forking";
      };
      Install.WantedBy = ["default.target"];
    };
  };


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


  programs.spacemacs = import ./programs/spacemacs.nix {
    config = config;
    pkgs = pkgs;
  };

  programs.fish = {
    enable = true;
    functions = {
      mx = "emacsclient -nw $argv";
    };
    shellInit = ''
      set -g EDITOR "emacsclient -nw"
      set -x DEVSHELL_SHELL $SHELL
      if test -n "$DEVSHELL"
      else
        set -x DEVSHELL ""
        set -x DEVSHELL_ICON ""
      end
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
        echo -n $DEVSHELL_ICON
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

}
