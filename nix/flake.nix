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
      eachSystem [system.x86_64-linux] (
        system: let
          pkgs = arch: (import nixpkgs {
            inherit system;
            crossSystem = {
              config = "${arch}-unknown-linux-musl";
              isStatic = true;
            };
          });
          build = which:
            with pkgs which;
              builtins.listToAttrs (map (
                  {pname, ...} @ value: {
                    name = pname;
                    inherit value;
                  }
                ) [
                  (containerd.overrideAttrs {
                    BUILDTAGS = "seccomp no_aufs no_btrfs no_devmapper no_zfs";
                    buildPhase =
                      builtins.replaceStrings ["binaries"] [
                        (builtins.concatStringsSep " " ([
                            "bin/containerd"
                            "bin/containerd-shim"
                            "bin/containerd-shim-runc-v2"
                          ]
                          ++ lib.lists.optionals (which == "i686") [
                            "SHIM_CGO_ENABLED=1"
                          ]))
                      ]
                      containerd.buildPhase;
                  })
                  cryptsetup
                  dosfstools
                  eudev
                  grub2
                  inih
                  iptables
                  ipxe
                  json_c
                  kmod
                  libaio
                  libseccomp
                  liburcu
                  linux-firmware
                  lvm2
                  musl
                  openssl
                  popt
                  runc
                  util-linux
                  xfsprogs
                ]);
          archlist = ["i686" "x86_64"];
        in {
          # Build each package via its attr name, e.g. .#i686.linux-firmware.
          packages = builtins.listToAttrs (map (name: {
              inherit name;
              value = build name;
            })
            archlist);
        }
      );
}
