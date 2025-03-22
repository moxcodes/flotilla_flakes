{ config
, lib
, pkgs
, python_manager
, ...
}:
with lib; let
  cfg = config.programs.emacs_conf;
in
{ }
