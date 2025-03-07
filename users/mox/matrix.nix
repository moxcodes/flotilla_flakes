{ config, lib, pkgs, ...}:
with lib;
{
  config = {
    home.packages = [
      matrix-commander-rs
      element-web
    ];
  };
}
