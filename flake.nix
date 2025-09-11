{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  # note that while *in principle* home-manager package can be
  # installed via nixpkgs, if we do that it doesn't bring its
  # module along, so we have to pull in from github.
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    nixpkgs,
    home-manager,
    sops-nix,
    self,
  } @ inputs: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    formatter = forAllSystems (system: let
        pkgs = import nixpkgs {inherit system;};
      in
        pkgs.alejandra);
    nixosConfigurations = {
      rocinante = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          sops-nix.nixosModules.sops
          (import ./users
            {
              home_manager_path = home-manager.outPath;
              sysname = "rocinante";
              meta_conf = (import ./customizations.nix).laptop_size;
            })
        ];
      };
      ares = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./surface_go_configuration.nix
          (import ./users
            {
              home_manager_path = home-manager.outPath;
              sysname = "ares";
              meta_conf = (import ./customizations.nix).tablet_size;
            })
        ];
      };
    };
    homeConfigurations = forAllSystems(system:
      let
        pkgs = import nixpkgs {inherit system;};
      in {
        jordan-moxon-shell =
          let
            meta_conf = (import ./customizations.nix).laptop_size;
          in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              imports = [
                ./users/mox/modules/python_manager.nix
                ((import ./users/mox/backend_dev_edc.nix {custom = meta_conf; }) pkgs.lib pkgs)
                ((import ./users/mox/shell.nix {custom = meta_conf; })  pkgs.lib pkgs)
              ];
              home.username = "jordan.moxon";
              home.homeDirectory = "/home/jordan.moxon";
              home.stateVersion = "22.11";
              programs.home-manager.enable = true;
            };
      });
  };
}
