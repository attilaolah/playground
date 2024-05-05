{pkgs, ...}:
with pkgs.lib; let
  v = import ../versions.nix;

  echo = getExe' pkgs.coreutils "echo";
  git = getExe pkgs.git;
in (pkgs.writeShellScriptBin "prepare" ''
  set -euxo pipefail

  # Prepare Git config.
  # Required to make commits to avoid dirty repos.
  ${git} config --global user.name > /dev/null || \
  ${git} config --global user.name ci
  ${git} config --global user.email > /dev/null || \
  ${git} config --global user.email ci@dorn.haus

  # Export version numbers as output.
  # Allows subsequent steps to use it as input values.
  ${echo} "v_bldr=${v.bldr}" >> "$GITHUB_OUTPUT"
  ${echo} "v_pkgs=${v.pkgs}" >> "$GITHUB_OUTPUT"
  ${echo} "v_toolchain=${v.toolchain}" >> "$GITHUB_OUTPUT"
  ${echo} "v_tools=${v.tools}" >> "$GITHUB_OUTPUT"
'')
