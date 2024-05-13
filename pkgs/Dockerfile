FROM nixos/nix

RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
RUN echo "sandbox = true" >> /etc/nix/nix.conf

RUN mkdir /build
ADD . /build

ARG ARCH=x86_64

WORKDIR /build
RUN nix build .#${ARCH}.cryptsetup
