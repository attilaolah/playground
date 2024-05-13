{
  description = "Playground.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    with flake-utils.lib;
      eachSystem [
        system.x86_64-linux
      ] (
        system: let
          pkgs = arch: (import nixpkgs {
            inherit system;
            crossSystem = {
              config = "${arch}-unknown-linux-musl";
              isStatic = true;
            };
          });
        in {
          packages = {
            i686 = with pkgs "i686"; {inherit cryptsetup;};
            x86_64 = with pkgs "x86_64"; {inherit cryptsetup;};
          };
        }
      );
}
