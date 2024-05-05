{pkgs, ...}:
with pkgs.lib; let
  make = getExe' pkgs.gnumake "make";
in (pkgs.writeShellScriptBin "bldr-build" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/bldr"

  ${make} \
    REGISTRY="$NSC_CONTAINER_REGISTRY" \
    PLATFORM=linux/386 \
    PUSH=true \
    image-bldr
'')
