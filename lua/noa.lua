local M = {}

local function buflist()
  local current
  local list = {}
  local cbuf = vim.fn.bufnr()

  for i = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(i) == 1 then
      if i == cbuf then current = #list + 1 end

      list[#list + 1] = i
    end
  end

  return list, current
end

local function hl(text, group)
  return (group and "%#" .. group .. "#" or "%*") .. text
end

function M.tab_bufname(bufnr)
  local name = vim.fn.bufname(bufnr)

  if name == "" then
    name = "[No Name]"
  end

  if strwidth(name) > 14 then
    local ext = vim.fn.fnamemodify(name, ":e")
    local suffix = ext == "" and "" or "." .. ext

    name = truncate(name, 14 - strwidth(suffix)) .. suffix
  end

  return name
end

function M.ui_diffstatus()
  local status = vim.b.gitsigns_status_dict or {}
  local text = ""

  if status.added and status.changed and status.removed then
    text = text
      .. hl("+" .. status.added,   "Added")   .. " "
      .. hl("~" .. status.changed, "Changed") .. " "
      .. hl("-" .. status.removed, "Removed")
  end

  return text
end

function M.ui_bufname()
  local icon, icon_hl = MiniIcons.get("filetype", vim.bo.filetype)

  return hl(icon .. " ", icon_hl) .. hl("%f") .. hl("%h%w%m%r", "NonText")
end

local severity = vim.diagnostic.severity

function M.ui_diagnostic()
  local text = ""
  local diagnostics = vim.diagnostic.count()

  if diagnostics[severity.ERROR] then
    text = text
      .. hl(" ", "DiagnosticError")
      .. hl(diagnostics[severity.ERROR])
  end

  if diagnostics[severity.WARN] then
    text = text
      .. hl(" ", "DiagnosticWarn")
      .. hl(diagnostics[severity.WARN])
  end

  return text
end

function M.statusline()
  return " %{%v:lua.require'noa'.ui_bufname()%}"
      .. " %{%v:lua.require'noa'.ui_diagnostic()%}"
      .. " %{%v:lua.require'noa'.ui_diffstatus()%}"
      .. "%="
      .. hl("%l,%c%V %P")
end

function M.tabline(bufnr)
  local list, current = buflist()
  local line = ""

  local bufstart = 1
  local bufend = #list

  if (bufend - bufstart + 1) * 24 > vim.o.columns then

  end

  for i = bufstart, bufend do
    local bufnr = list[i]

    line = line .. hl(
      " %-14.14(%{v:lua.require'noa'.tab_bufname(" .. bufnr .. ")}%) "
        .. (vim.fn.getbufvar(bufnr, "&modified") == 1 and "●" or "○")
        .. " ",
      i == current and "TabLineSel")
  end

  return line .. hl("", "TabLineFill")
end

function M.winbar()
  return ""
end

function truncate(text, len)
  while strwidth(text) > len - 1 do
    text = vim.fn.slice(text, 0, -1)
  end

  return text .. string.rep(" ", len - strwidth(text) - 1) .. "…"
end

function strwidth(text)
  return vim.api.nvim_strwidth(text)
end

return M
