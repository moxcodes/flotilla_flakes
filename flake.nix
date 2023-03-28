{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  # note that while *in principle* home-manager package can be
  # installed via nixpkgs, if we do that it doesn't bring its
  # module along, so we have to pull in from github.
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  outputs = {nixpkgs, home-manager, self}@inputs: {

    # homeConfigurations = {
    #   mox = home-manager.lib.homeManagerConfiguration {
    #     modules = [ (import ./home.nix) ];
    #   };
    # };
    nixosConfigurations = {
      rocinante = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
        modules = [
            ./configuration.nix
            (import ./users
                    { home_manager_path = home-manager.outPath; })
          ];
      };
    };
  };
}
