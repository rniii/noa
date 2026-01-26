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
