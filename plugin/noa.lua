vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.list = true
vim.opt.listchars = {
  extends  = ">",
  precedes = "<",
  tab      = "  ",
  trail    = "•",
}

vim.opt.statusline = "%!v:lua.require'noa'.statusline()"
vim.opt.tabline = "%!v:lua.require'noa'.tabline()"
-- vim.opt.winbar = "%!v:lua.require'noa'.winbar()"
vim.opt.showtabline = 2

vim.cmd.colorscheme "noa"
