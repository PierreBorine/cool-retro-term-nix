{
  description = "Terminal emulator which mimics the old cathode display, with nix compatible config.";

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

    homeModules = {
      default = self.homeModules.crt;
      cool-retro-term = self.homeModules.crt;
      crt = import ./nix/hm.nix self;
    };

    homeManagerModules = let
      deprecateTo = builtins.warn "cool-retro-term-nix: `homeManagerModules` is deprecated, please use `homeModules` instead.";
    in {
      default = deprecateTo self.homeModules.crt;
      cool-retro-term = deprecateTo self.homeModules.crt;
      crt = deprecateTo self.homeModules.crt;
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
