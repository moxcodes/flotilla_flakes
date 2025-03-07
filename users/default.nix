{
  home_manager_path,
  sysname,
}: {
  config,
  pkgs,
  ...
}: {
  imports = [
    "${home_manager_path}/nixos/default.nix"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = let
      usernames =
        pkgs.lib.filterAttrs
        (n: _: n != "default.nix" && ! pkgs.lib.hasPrefix "." n)
        (builtins.readDir ./.);
    in
      builtins.listToAttrs (
        map (
          username: {
            name = "${username}";
            value = (
              import ./${username}/home.nix
              {
                custom =
                  import ./${username}/customizations.nix
                  {
                    sysname = sysname;
                    config = config;
                    pkgs = pkgs;
                  };
              }
            );
          }
        ) (builtins.attrNames usernames)
      );
  };
}
