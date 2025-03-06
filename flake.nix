{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  # note that while *in principle* home-manager package can be
  # installed via nixpkgs, if we do that it doesn't bring its
  # module along, so we have to pull in from github.
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {nixpkgs, home-manager, sops-nix, self}@inputs: {

    nixosConfigurations = {
      rocinante = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            sops-nix.nixosModules.sops
            (import ./users
                    { home_manager_path = home-manager.outPath; sysname = "ares"; })
          ];
      };
      ares = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./surface_go_configuration.nix
            (import ./users
                    { home_manager_path = home-manager.outPath; sysname = "ares"; })
          ];
      };
    };
  };
}
