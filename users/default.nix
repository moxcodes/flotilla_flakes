{ home_manager_path }:
{ config, pkgs, ... }:
{
  imports = [
    "${home_manager_path}/nixos/default.nix"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = let
              usernames = pkgs.lib.filterAttrs
                ( n: _: n != "default.nix" && ! pkgs.lib.hasPrefix "." n )
                (builtins.readDir ./.);
            in
              builtins.listToAttrs (map (username: { name = "${username}"; value = import ./${username}/home.nix; }) (builtins.attrNames usernames));
  };
}