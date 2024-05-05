{
  self,
  flake-utils,
  system,
  pkgs,
  ...
} @ inputs: {
  packages = rec {
    prepare = import ./prepare.nix inputs;
    bldr-patch-host = import ./bldr-patch-host.nix inputs;
    bldr-build-host = import ./bldr-build-host.nix inputs;
    pkgs-patch-host = import ./pkgs-patch-host.nix inputs;
    pkgs-build-host = import ./pkgs-build-host.nix inputs;

    # Provide a default so that `nix build` would build each step.
    default = pkgs.symlinkJoin {
      name = "all";
      paths = [
        prepare
        bldr-patch-host
        bldr-build-host
        pkgs-patch-host
        pkgs-build-host
      ];
    };
  };

  apps = with flake-utils.lib; {
    prepare = mkApp {drv = self.packages.${system}.prepare;};
    bldr-patch-host = mkApp {drv = self.packages.${system}.bldr-patch-host;};
    bldr-build-host = mkApp {drv = self.packages.${system}.bldr-build-host;};
    pkgs-patch-host = mkApp {drv = self.packages.${system}.pkgs-patch-host;};
    pkgs-build-host = mkApp {drv = self.packages.${system}.pkgs-build-host;};
  };
}
