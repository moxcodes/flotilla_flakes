{custom}: {
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # CLI
    castero
    cmus
    cmusfm
    mplayer
    newsraft
    timg
 ];
}
