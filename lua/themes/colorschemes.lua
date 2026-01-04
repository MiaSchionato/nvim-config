local colorschemes = {
  ["solarized-osaka"]  =  "craftzdog/solarized-osaka.nvim",
  eldritch =  "eldritch-theme/eldritch.nvim",
  catppuccin = "catppuccin/nvim",
  tokyonight = "folke/tokyonight.nvim",
  ["rose-pine"] = "rose-pine/neovim",
  tokyodark = "tiagovla/tokyodark.nvim",
  ["night-owl"] = "oxfist/night-owl.nvim",
  NeoSolarized = "Tsuzat/NeoSolarized.nvim",
}

for name, link in pairs(colorschemes) do
  vim.pack.add({{ src = 'https://github.com/' .. link, name = name }})
end

local groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "WinBar",
  "WinBarNC",
  "WinSeparator",
  "VertSplit",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "FoldColumn",
  "EndOfBuffer",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "Pmenu",
  "PmenuSel",
  "PmenuSbar",
  "PmenuThumb",
  "Question",
  "QuickFixLine",
  "MsgArea",
}

vim.keymap.set('n','<leader>ct', function()
   for _, colors in pairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = colors, link = false })
    local new_hl = vim.tbl_extend("force", hl, { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, colors, new_hl)
   end
end, {silent = true, desc = "Transparent mode"})
