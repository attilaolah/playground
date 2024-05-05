{
  self,
  flake-utils,
  system,
  pkgs,
  ...
} @ inputs: {
  packages = rec {
    prepare = import ./prepare.nix inputs;

    # Provide a default so that `nix build` would build each step.
    default = pkgs.symlinkJoin {
      name = "all";
      paths = [prepare];
    };
  };

  apps = with flake-utils.lib; {
    prepare = mkApp {drv = self.packages.${system}.prepare;};
  };
}
