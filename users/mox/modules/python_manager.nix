{ config, lib, pkgs, ...}:
let
    cfg = config.python_manger;
in
with lib;
{
  options = with types; {
    python_manager = {
      enable = mkEnableOption "python manager";
      python_packages = mkOption {
        type = listOf package;
        default = [];
        merge = (pkg_lists:
          lists.unique (lists.flatten pkg_lists));
      };
      python = mkOption {
        type = package;
        default = pkgs.python3;
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [
      cfg.python.withPackages(ps:
        lib.lists.forEach cfg.python_packages (pack: ps.${pack}))
    ];
  };
}
