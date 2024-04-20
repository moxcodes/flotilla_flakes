{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.programs.spacemacs;
  
  spacemacsLayerType = types.submodule {
    options = with types; {
      variables = mkOption {
        type = attrsOf str;
      };
    };
  };

in {
  options = with types; {
    programs.spacemacs = {
      enable = mkEnableOption "spacemacs, a configuration layer for emacs";
    }
    layers = mkOption { type = attrsOf scapemacsLayerType; default = {}; }
  }
  config = mkIf cfg.enable {
    home.file.".spacemacs-test" = {
      source = {
        pkgs.writeTextFile {
          name = ".spacemacs";
          text = let
              layer_var_acc = acc: name: value: (
                acc + "\n       " + name + " " + value);
              layer_acc = acc: name: value: (
                acc + "\n     (" + name + ( attrsets.foldlAttrs layer_var_acc " :variables " cfg.styles) + ")");
            in ''
            (defun dotspacemacs/layers ()
              "Layer configuration"
              (setq-default
               dotspacemacs-distribution 'spacemacs-base
               dotspacemacs-enable-lazy-installation 'unused
               dotspacemacs-ask-for-lazy-installation t
               dotspacemacs-configuration-layer-path '()
               dotspacemacs-configuration-layers
               '('' + (attrsets.foldlAttrs layer_acc "" cfg.layers) + '')
        };
      };
    };
  };
}