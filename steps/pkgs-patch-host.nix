{pkgs, ...}:
with pkgs.lib; let
  git = getExe pkgs.git;
  sed = getExe' pkgs.gnused "sed";
in (pkgs.writeShellScriptBin "pkgs-patch-host" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/pkgs"

  ${sed} --in-place \
    --expression="s|ghcr.io/siderolabs/bldr:.*|$NSC_CONTAINER_REGISTRY/siderolabs/bldr:$(
      ${git} -C "$GITHUB_WORKSPACE/bldr" describe --tag --always --dirty
    )|g" \
    Pkgfile

  ${git} add .
  ${git} commit --message "patch: update bldr tag"
'')
