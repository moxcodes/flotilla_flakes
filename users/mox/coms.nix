{custom}: { config, lib, pkgs, ...}:
with lib;
{
  config = {
    home.packages = with pkgs; [
      element-web
      irssi
      matrix-commander-rs
      signal-desktop
    ];
  };
}
