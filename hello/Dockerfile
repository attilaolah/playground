FROM nixos/nix

RUN nix-channel --update
RUN echo "sandbox = true" >> /etc/nix/nix.conf
RUN nix-build '<nixpkgs>' -A hello
RUN nix-build '<nixpkgs>' -A hello -I nixpkgs=channel:nixos-23.11 --arg crossSystem '{ config = "x86_64-unknown-linux-musl"; }'
