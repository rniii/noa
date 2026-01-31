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

function M.statusline()
  return " %{%v:lua.require'noa'.ui_bufname()%}"
      .. " %{%v:lua.require'noa'.ui_diffstatus()%}"
      .. "%="
      .. hl("%l,%c%V %P")
end

function M.tabline(bufnr)
  if bufnr == nil then
    local list, current = buflist()
    local line = ""

    local bufstart = 1
    local bufend = #list

    if (bufend - bufstart + 1) * 24 > vim.o.columns then

    end

    for i = bufstart, bufend do
      line = line .. hl(
        " %{v:lua.require'noa'.tabline(" .. list[i] .. ")} ",
        i == current and "TabLineSel")
    end

    return line .. hl("", "TabLineFill")
  end

  local name = vim.fn.bufname(bufnr)

  if name == "" then
    name = "[No Name]"
  end

  if strwidth(name) > 14 then
    local ext = vim.fn.fnamemodify(name, ":e")
    local suffix = ext == "" and "" or "." .. ext

    name = truncate(name, 14 - strwidth(suffix)) .. suffix
  end

  return (name .. string.rep(" ", 14 - #name))
    .. " " .. (vim.fn.getbufvar(bufnr, "&modified") == 1 and "●" or "○")
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
