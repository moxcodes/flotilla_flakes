{custom}: { config, lib, pkgs, ...}:
with lib;
{
  config = {
    home.packages = with pkgs; [
      irssi
    ]
    ++ lib.optionals (custom.resources == "large") [
      fluffychat
      matrix-commander-rs
      signal-desktop
    ];
  };
}
