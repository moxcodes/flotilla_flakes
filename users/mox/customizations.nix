{
  sysname,
  config,
  pkgs,
  ...
}: {
  fontsize =
    {
      "ares" = 10;
      "rocinante" = 7;
    }
    ."${sysname}";
}
