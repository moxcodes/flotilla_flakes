{
  config,
  pkgs,
  ...
}: let
  syncthing_monitor_py = pkgs.writeText "syncthing_monitor.py" (import ./syncthing_report_status_tmux.py);
in {
  enable = true;
  prefix = "C-z";
  shortcut = "z";
  terminal = "tmux-256color";
  sensibleOnTop = true;
  historyLimit = 50000;
  # Note: redundant continuum load needed because it must be the last thing
  # loaded after other things change the right status
  extraConfig = let
    # need to repeat the command in the conf directly; tmux doesn't have
    #  native loop support and calling out to a shell wrecks performance
    repeat_string = {
      str,
      sep,
      num,
    }:
      toString (pkgs.lib.strings.intersperse sep
        (map (a: str) (pkgs.lib.lists.range 1 num)));
    # good alternatives are  ,   etc..
    left_separator = " ";
    right_separator = " ";
    left_bg_colors = ["colour40" "colour22" "colour236" "default" "default"];
    right_bg_colors = ["colour40" "colour22" "colour236" "default" "default"];
    left_fg_colors = ["colour16,bold" "colour255,bold" "colour46" "colour46" "colour46"];
    right_fg_colors = ["colour16,bold" "colour255,bold" "colour46" "colour46" "colour46"];
  in
    ''
      bind-key -T copy-mode M-w send-keys -X copy-pipe
      bind-key -T copy-mode M-p send-keys -X previous-paragraph
      bind-key -T copy-mode M-n send-keys -X next-paragraph
      bind-key -T copy-mode M-P ''
    + (repeat_string {
      str = "send-keys -X cursor-up";
      sep = "\\;";
      num = 5;
    })
    + ''
      bind-key -T copy-mode M-N ''
    + (repeat_string {
      str = "send-keys -X cursor-down";
      sep = "\\;";
      num = 5;
    })
    + ''
      bind-key -T copy-mode O send-keys -X copy-pipe "xargs -I {} tmux run-shell -b 'cd #{pane_current_path}; xdg-open \"{}\" > /dev/null'"
      # Switch betewen panes using alt + arrow
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-up select-pane -U
      bind -n M-Down select-pane -D

      bind -n M-S-Up move-pane -h -t '.{up-of}'
      bind -n M-S-Right move-pane -t '.{right-of}'
      bind -n M-S-Left move-pane -t '.{left-of}'
      bind -n M-S-down move-pane -h -t '.{down-of}'


      bind -T copy-mode -n M-Left select-pane -L
      bind -T copy-mode -n M-Right select-pane -R
      bind -T copy-mode -n M-up select-pane -U
      bind -T copy-mode -n M-Down select-pane -D

      # Use shift + arrow key to move between windows in a session
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      set -g status-left-length 64
      set -g status-right-length 100
      set -g status-justify centre
      set-option -s status-interval 1
      set -g pane-border-style fg=colour22
      set -g mode-style "fg=colour48, bg=colour236"
      set -g status-bg colour16

      set-option -g status-left "\
      #[fg=${builtins.elemAt left_fg_colors 0}, bg=${builtins.elemAt left_bg_colors 0}]\
      #{=/9/…:host}  #(readlink /nix/var/nix/profiles/system | cut -d- -f2) \
      #[fg=${builtins.elemAt left_bg_colors 0}, bg=${builtins.elemAt left_bg_colors 1}]${left_separator}\
      #[fg=${builtins.elemAt left_fg_colors 1},bg=${builtins.elemAt left_bg_colors 1}]󰺔 #S \
      #[fg=${builtins.elemAt left_bg_colors 1},bg=${builtins.elemAt left_bg_colors 2}]${left_separator}\
      #[fg=${builtins.elemAt left_fg_colors 2},bg=${builtins.elemAt left_bg_colors 2}]#{=/15/…:#(bash ~/tools/scripts/configuration/path_shortener/shorten_path.bash '#{pane_current_path}')} \
      #[fg=${builtins.elemAt left_bg_colors 2}, bg=${builtins.elemAt left_bg_colors 3}]${left_separator}\
      #[fg=${builtins.elemAt left_fg_colors 3}, bg=${builtins.elemAt left_bg_colors 3}]#{=/5/…:pane_current_command} \
      "

      set-option -g status-right "\
      #[reverse,fg=${builtins.elemAt right_bg_colors 2},bg=${builtins.elemAt right_bg_colors 3}]${right_separator}\
      #[noreverse,fg=${builtins.elemAt right_fg_colors 2},bg=${builtins.elemAt right_bg_colors 2}]\
      #(gitmux -cfg ~/.config/gitmux/gitmux.conf #{pane_current_path})#[noreverse,fg=${builtins.elemAt right_fg_colors 2},bg=${builtins.elemAt right_bg_colors 2}] \
      #[reverse,fg=${builtins.elemAt right_bg_colors 1},bg=${builtins.elemAt right_bg_colors 2}]${right_separator}\
      #[noreverse,fg=${builtins.elemAt right_fg_colors 1},bg=${builtins.elemAt right_bg_colors 1}]\
      #(python3 $syncthing_monitor_py --bg-color ${builtins.elemAt right_bg_colors 1} --fg-color ${builtins.elemAt right_fg_colors 1})\
      #[reverse,fg=${builtins.elemAt right_bg_colors 0}, bg=${builtins.elemAt right_bg_colors 1}]${right_separator}\
      #[noreverse,fg=${builtins.elemAt right_fg_colors 0}, bg=${builtins.elemAt right_bg_colors 0}]%Y_%m_%d|%H:%M:%S"

      set-window-option -g window-status-current-format "\
      #[fg=colour255, bg=colour40]▏\
      #[fg=colour16, bg=colour40]#I:#[bold]#W-#P\
      #[fg=colour255, bg=colour40]▕"

      set-window-option -g window-status-format "\
      #[fg=colour255, bg=default]▏\
      #[noreverse,fg=colour46, bg=default]#I:#[bold]#W\
      #[fg=colour255, bg=default]▕"

      run-shell ${pkgs.tmuxPlugins.continuum.outPath}/share/tmux-plugins/continuum/continuum.tmux
    '';
  plugins = with pkgs; [
    {
      plugin = tmuxPlugins.resurrect;
      extraConfig = ''
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-processes '"~ssh->ssh *" "~emacs->emacs *" "~emacsclient->emacsclient *" "~watch->watch *" "~man->man *"'
      '';
    }
    {
      plugin = tmuxPlugins.continuum;
      extraConfig = ''
        set -g @continuum-save-interval '1'
      '';
    }
    {
      plugin = tmuxPlugins.jump;
    }
    {
      plugin = tmuxPlugins.tmux-thumbs;
    }
    {
      plugin = tmuxPlugins.open;
    }
    {
      plugin = tmuxPlugins.sessionist;
    }
  ];
}
