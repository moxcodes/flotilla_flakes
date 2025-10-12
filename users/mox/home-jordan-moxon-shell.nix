# TODO this is bad factoring!
# figure out a better way. Probably more flakes
{
  config,
  pkgs,
  lib,
  ...
}@args:
let
  meta_conf = (import ../../customizations.nix).laptop_size;
in
{
  imports = [
    ./modules/python_manager.nix
    (import ./backend_dev_edc.nix {custom = meta_conf; })
    (import ./shell.nix {custom = meta_conf; })
  ];
  home.username = "jordan.moxon";
  home.homeDirectory = "/home/jordan.moxon";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
