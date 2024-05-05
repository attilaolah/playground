{
  self,
  flake-utils,
  system,
  pkgs,
  ...
} @ inputs: {
  packages = rec {
    bldr-build = import ./bldr-build.nix inputs;
    bldr-patch = import ./bldr-patch.nix inputs;
    prepare = import ./prepare.nix inputs;

    # Provide a default so that `nix build` would build each step.
    default = pkgs.symlinkJoin {
      name = "all";
      paths = [
        bldr-build
        bldr-patch
        prepare
      ];
    };
  };

  apps = with flake-utils.lib; {
    bldr-build = mkApp {drv = self.packages.${system}.bldr-build;};
    bldr-patch = mkApp {drv = self.packages.${system}.bldr-patch;};
    prepare = mkApp {drv = self.packages.${system}.prepare;};
  };
}
