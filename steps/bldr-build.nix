{pkgs, ...}:
with pkgs.lib; let
  echo = getExe' pkgs.coreutils "echo";
  git = getExe pkgs.git;
  make = getExe' pkgs.gnumake "make";
in (pkgs.writeShellScriptBin "bldr-patch" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/bldr"

  ${make} \
    REGISTRY="$NSC_CONTAINER_REGISTRY" \
    PLATFORM=linux/amd64 \
    PUSH=true \
    image-bldr

  ${echo} "tag=$(${git} describe --tag --always --dirty)" >> "$GITHUB_OUTPUT"
'')
