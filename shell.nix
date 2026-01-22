let
  inherit (import <nixpkgs> { })
    callPackage
    mkShell
    neovim-unwrapped
    wrapNeovimUnstable
    ;

  noa-vim = callPackage ./. { };

  wrapped-neovim = wrapNeovimUnstable neovim-unwrapped
    { plugins = [ noa-vim ];
    };
in

mkShell
  { buildInputs = [ wrapped-neovim ];
  }
