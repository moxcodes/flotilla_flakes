{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.programs.gitmux;
  
  gitmuxNameType = 

  gitmuxStyleType = lib.types.submodule {
    options = {
      name = {
        type = lib.types.enum [
                 "branch" "hashprefix" "ahead" "behind" "staged" "conflict"
                 "modified" "untracked" "stashed" "insertions" "deletions"
                 "clean"];
      };
      symbol = {
        type = lib.types.str;
      };
      style = {
        type = lib.types.str;
      };
    };
  };
in {
  options = {
    programs.gitmux = {
      enable = lib.mkEnableOption "gitmux, plugin for tmux to show git status information";
      
      branch_max_len = lib.mkOption {
        type = lib.types.int;
      };

      styles = lib.mkOption {
        type = lib.types.listOf gitmuxStyleType;
      };
      layout = lib.mkOption {
        type = lib.types.str;
        default = ''[branch, remote-branch, divergence, " - ", flags]''
      };
    }
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.gitmux ];
    xdg.configFile."gitmux/gitmux.conf".source = 
  };

}