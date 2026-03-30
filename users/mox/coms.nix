{custom}: { config, lib, pkgs, ...}:
with lib;
{
  config = {
    home.packages = with pkgs; [
      irssi
      fluffychat
      matrix-commander-rs
      signal-desktop
    ];
  };
}
