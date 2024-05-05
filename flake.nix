{
  description = "Playground.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
        import ./steps (
          inputs
          // {
            inherit system;
            pkgs = import nixpkgs {inherit system;};
          }
        )
    );
}
