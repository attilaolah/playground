{pkgs, ...}:
with pkgs.lib; let
  echo = getExe' pkgs.coreutils "echo";
  git = getExe pkgs.git;
  patch = getExe pkgs.patch;
in (pkgs.writeShellScriptBin "bldr-patch" ''
  set -euxo pipefail
  cd "$GITHUB_WORKSPACE/bldr"

  ${patch} --strip 1 < "$GITHUB_WORKSPACE/patches/bldr.patch"
  ${git} add .
  ${git} commit --message "feat: add linux/i386 support"

  ${echo} "tag=$(${git} describe --tag --always --dirty)" >> "$OUT"
'')
