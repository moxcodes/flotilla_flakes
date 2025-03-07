{
  sysname,
  config,
  pkgs,
  ...
}: {
  fontsize =
    {
      "ares" = 10.0;
      "rocinante" = 7.0;
    }
    ."${sysname}";
  
}
