{pkgs, ...}:
with pkgs.lib; let
  make = getExe' pkgs.gnumake "make";
in (pkgs.writeShellScriptBin "pkgs-build-host" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/pkgs"

  ${make} \
    REGISTRY="$NSC_CONTAINER_REGISTRY" \
    PLATFORM=linux/amd64 \
    PUSH=true \
    ca-certificates \
    fhs
'')
