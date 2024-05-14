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
          pkglist = which:
            with pkgs which;
              builtins.listToAttrs (map (
                  {pname, ...} @ value: {
                    name = pname;
                    inherit value;
                  }
                ) [
                  cryptsetup
                  dosfstools
                  inih
                  iptables
                  json_c
                  libaio
                  libseccomp
                  liburcu
                  linux-firmware
                  lvm2
                  musl
                  openssl
                  popt
                  runc
                ]);
          archlist = ["i686" "x86_64"];
        in {
          packages = builtins.listToAttrs (map (name: {
              inherit name;
              value = pkglist name;
            })
            archlist);
        }
      );
}
