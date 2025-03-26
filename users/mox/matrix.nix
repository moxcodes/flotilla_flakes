{custom}: { config, lib, pkgs, ...}:
with lib;
{
  config = {
    home.packages = with pkgs; [
      matrix-commander-rs
      element-web
      signal-desktop
    ];
  };
}
