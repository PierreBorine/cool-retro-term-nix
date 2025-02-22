{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = self.packages.${system}.crt;
        cool-retro-term = self.packages.${system}.crt;
        crt = pkgs.libsForQt5.callPackage ./nix/cool-retro-term.nix {};
      }
    );

    homeManagerModules = {
      default = self.homeManagerModules.crt;
      cool-retro-term = self.homeManagerModules.crt;
      crt = import ./nix/hm.nix self;
    };

    overlays = {
      default = self.overlays.crt;
      cool-retro-term = self.overlays.crt;
      crt = _: prev: {
        cool-retro-term = self.packages.${prev.system}.default;
      };
    };
  };
}
