{pkgs, ...}:
with pkgs.lib; let
  git = getExe pkgs.git;
  head = getExe' pkgs.coreutils "head";
  sed = getExe' pkgs.gnused "sed";
in (pkgs.writeShellScriptBin "bldr-patch-target" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/bldr"

  v="$(
    ${git} -C "$GITHUB_WORKSPACE/pkgs" rev-parse HEAD | \
    ${head} --bytes 7
  )"
  ${sed} --in-place \
    --regexp-extended \
    --expression="s|ghcr.io/siderolabs/([^:]+):\S+|$NSC_CONTAINER_REGISTRY/siderolabs/\1:$v|g" \
    Dockerfile

  ${git} add .
  ${git} commit --message "patch: use local dependencies"
'')
