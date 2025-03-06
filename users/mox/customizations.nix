{ config, lib, pkgs, sysname, ...}:
{
  fontsize = {
    "ares" = 7;
    "rocinante" = 10;
  }."${sysname}";
}
