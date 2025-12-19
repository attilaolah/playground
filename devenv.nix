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
    isort = {};
    pyupgrade = {};
    shellcheck = {};
    typos = {};

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
