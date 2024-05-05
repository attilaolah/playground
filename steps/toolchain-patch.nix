{pkgs, ...}:
with pkgs.lib; let
  git = getExe pkgs.git;
  sed = getExe' pkgs.gnused "sed";
in (pkgs.writeShellScriptBin "toolchain-patch" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/toolchain"

  ${sed} --in-place \
    --expression="s|ghcr.io/siderolabs/bldr:.*|$NSC_CONTAINER_REGISTRY/siderolabs/bldr:$(
      ${git} -C "$GITHUB_WORKSPACE/bldr" describe --tag --always --dirty
    )|g" \
    Pkgfile
  ${sed} --in-place \
    --expression='s|^(\s*)(case .ARCH in)|\1\2\n\1    i386)\n\1        arch="i386"\n\1    ;;|' \
    linux-headers/pkg.yaml

  ${git} add .
  ${git} commit --message "patch: update bldr tag, linux-headers config"
'')
