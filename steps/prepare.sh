#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell --packages git

# Prepare Git config.
# Required to make commits to avoid dirty repos.
git config --global user.name ci
git config --global user.email ci@dorn.haus

#echo "workspace=${GITHUB_WORKSPACE}" >> "${GITHUB_OUTPUT}"
#echo "registry=${NSC_CONTAINER_REGISTRY}" >> "${GITHUB_OUTPUT}"
#echo "builder_version=0.3.0" >> "${GITHUB_OUTPUT}"
#echo "toolchain_version=0.11.0" >> "${GITHUB_OUTPUT}"
#echo "talos_version=1.8.0-alpha.0" >> "${GITHUB_OUTPUT}"
