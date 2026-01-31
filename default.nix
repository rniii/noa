{
  lib,
  vimUtils,
}:

vimUtils.buildVimPlugin
  { pname   = "noa-vim";
    version = "0.0.0";

    src = lib.fileset.toSource
      { root = ./.;
        fileset = lib.fileset.gitTracked ./.;
      };
  }
