{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs)
    callPackage
    mkShell
    neovim-unwrapped
    vimPlugins
    wrapNeovimUnstable
    ;

  noa-vim = callPackage ./. { };

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped
    { plugins = with vimPlugins;
        [ noa-vim

          gitsigns-nvim
          mini-icons

          ( nvim-lspconfig.overrideAttrs
              { passthru.runtimeDeps = with pkgs;
                  [ typescript-language-server ];
              }
          )
          ( nvim-treesitter.withPlugins
              ( grammars: with grammars;
                  [ javascript typescript lua nix ]
              )
          )
        ];

      luaRcContent = ''
        require("mini.icons").setup { }

        vim.lsp.enable("ts_ls")

        vim.api.nvim_create_autocmd("FileType", { pattern = "*", callback = function()
          if vim.treesitter.query.get(vim.bo.filetype, "highlights") then
            vim.treesitter.start()
          end
        end })

        vim.cmd [[
        nnoremap <C-j> <Cmd>bnext<CR>
        nnoremap <C-k> <Cmd>bprev<CR>
        ]]

        vim.opt.rnu = true
      '';
    };
in

mkShell { buildInputs = [ neovim-wrapped ]; }
