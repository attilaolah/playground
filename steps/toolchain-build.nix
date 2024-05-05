{pkgs, ...}:
with pkgs.lib; let
  make = getExe' pkgs.gnumake "make";
in (pkgs.writeShellScriptBin "toolchain-build-target" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/toolchain"

  ${make} \
    REGISTRY="$NSC_CONTAINER_REGISTRY" \
    PLATFORM=linux/386 \
    PUSH=true \
    toolchain
'')
