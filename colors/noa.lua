vim.g.colors_name = "noa"

vim.opt.termguicolors = true

local function hi(name, val)
  val.force = true
  vim.api.nvim_set_hl(0, name, val)
end

vim.cmd [[hi clear]]

hi("Normal",       { fg = "#d7d0d5" })
hi("StatusLine",   { })
hi("TabLine",      { })
hi("TabLineSel",   { bg = "NvimDarkGray4" })
hi("WinBar",       { })
hi("StatusLineNC", { fg = "NvimLightGrey4" })
hi("WinBarNC",     { fg = "NvimLightGrey4" })

-- hi("@lsp.type.parameter", { fg = "#ff00ff" })
