{pkgs, ...}:
with pkgs.lib; let
  echo = getExe' pkgs.coreutils "echo";
  git = getExe pkgs.git;
  make = getExe' pkgs.gnumake "make";
in (pkgs.writeShellScriptBin "bldr-patch" ''
  cd "$${GITHUB_WORKSPACE}/bldr"
  export PLATFORM=linux/amd64
  export PUSH=true
  export REGISTRY="$${NSC_CONTAINER_REGISTRY}"
  ${make} image-bldr
  ${echo} "tag=$(${git} describe --tag --always --dirty)" >> "$${GITHUB_OUTPUT}"
'')
