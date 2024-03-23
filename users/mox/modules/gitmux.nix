{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.programs.gitmux;
  
  gitmuxSymbolType = types.submodule {
    options = with types; {
      branch = mkOption { type = str; default = "⎇ ";};
      hashprefix = mkOption { type = str; default = ":";};
      ahead = mkOption { type = str; default = "↑·";};
      behind = mkOption { type = str; default = "↓·";};
      staged = mkOption { type = str; default = "●";};
      conflict = mkOption { type = str; default = "✖";};
      modified = mkOption { type = str; default = "✚";};
      untracked = mkOption { type = str; default = "…";};
      stashed = mkOption { type = str; default = "⚑";};
      insertions = mkOption { type = str; default = "Σ";};
      deletions = mkOption { type = str; default = "Δ";};
      clean = mkOption { type = str; default = "";};
    };
  };

  gitmuxStyleType = types.submodule {
    options = with types; {
      clear = mkOption { type = str; default = "#[fg=white]";};
      state = mkOption { type = str; default = "#[fg=red,bold]";};
      branch = mkOption { type = str; default = "#[fg=white,bold]";};
      remote = mkOption { type = str; default = "#[fg=cyan]";};
      divergence = mkOption { type = str; default = "#[fg=yellow]";};
      staged = mkOption { type = str; default = "#[fg=green,bold]";};
      conflict = mkOption { type = str; default = "#[fg=red,bold]";};
      modified = mkOption { type = str; default = "#[fg=red,bold]";};
      untracked = mkOption { type = str; default = "#[fg=magenta,bold]";};
      stashed = mkOption { type = str; default = "#[fg=cyan,bold]";};
      insertions = mkOption { type = str; default = "#[fg=green]";};
      deletions = mkOption { type = str; default = "#[fg=red]";};
      clean = mkOption { type = str; default = "#[fg=green,bold]";};
    };
  };
in {
  options = {
    programs.gitmux = {
      enable = mkEnableOption "gitmux, plugin for tmux to show git status information";
      
      branch_max_len = mkOption {
        type = types.int;
        default = 0;
      };

      styles = mkOption {
        type = gitmuxStyleType;
        default = { };
      };

      symbols = mkOption {
        type = gitmuxSymbolType;
        default = { };
      };

      layout = mkOption {
        type = types.str;
        default = ''[branch, remote-branch, divergence, " - ", flags]'';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.gitmux ];
    xdg.configFile."gitmux/gitmux.conf".text = 
      let
        accumulator = acc: name: value: (
          acc + "\n        " + name + ": \"" + value + "\"");
      in ''
tmux:
    symbols:'' +
         ( attrsets.foldlAttrs accumulator "" cfg.symbols) + 
         "\n    styles:" + 
         ( attrsets.foldlAttrs accumulator "" cfg.styles) + 
         "\n    layout: " + cfg.layout +
         "\n    options:" +
         "\n        branch_max_len: " + toString(cfg.branch_max_len) +
         "\n        branch_trim: right" +
         "\n        ellipsis: …" +
         "\n        hide_clean: false\n";
  };
}