{pkgs, ...}: let
  inherit (pkgs.lib) getExe;
  git = getExe pkgs.git;
in (pkgs.writeShellScriptBin "prepare" ''
  ${git} config --global user.name > /dev/null || \
  ${git} config --global user.name ci
  ${git} config --global user.email > /dev/null || \
  ${git} config --global user.email ci@dorn.haus
'')
