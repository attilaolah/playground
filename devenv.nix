{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) mapAttrs;
in {
  packages = with pkgs; [
    pyright
    ruff
  ];

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = mapAttrs (name: value: value // {enable = true;}) {
    alejandra = {};
    black = {};
    pyupgrade = {};
    shellcheck = {};
    typos = {};

    isort = let
      package = pkgs.usort;
    in {
      inherit package;
      entry = "${lib.getExe package} check";
    };

    # Others
    prettier = {
      types_or = [
        "json"
        "markdown"
        "toml"
      ];
    };
    spellcheck = {
      entry = lib.getExe pkgs.codespell;
    };
  };
}
