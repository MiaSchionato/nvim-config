local M = {}

local  colors_hl= {
  n = "%#BlueMode#",
  i = "%#EmeraldMode#",
  v = "%#PurpleMode#",
  V = "%#WatermelonMode#",
  c = "%#TanMode#",
  t = "%#PlantMode#",
  nt = "%#BlueMode#",
}
local icons_group = require('omakase.nightflyPalette').icons_group

function M.MyStatusLine()
  local m = vim.api.nvim_get_mode().mode
  local highlight = colors_hl[m] or "%#Statusline#"

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local diag_str = errors > 0 and string.format(" %%#DiagnosticError#  %d ", errors) or ""

  local filename = "%t %m"
  local cursor_location = "%l:%c"
  local ft = vim.bo.filetype
  local data = icons_group[ft] or icons_group['default_icon']

  if vim.bo.buftype == "terminal" then
    data = icons_group['terminal']
    filename =  vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  end

    -- Pegamos o ícone correspondente ao filetype
  local icon = string.format("%%#%s#%s %%#StatusLine#%s ", data.hl, data.icon, ft)

  return table.concat({
    highlight, " ", m:upper(), " ",
    "%#Statusline#"," ", diag_str, filename,
    "%=",
    "%#Statusline#",icon, cursor_location,
  })
end


return M
