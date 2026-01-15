local utils = require("configs.functions")
local colorschemes = {
  ["solarized-osaka"]  =  "craftzdog/solarized-osaka.nvim",
  eldritch =  "eldritch-theme/eldritch.nvim",
  ethereal =  "bjarneo/ethereal.nvim",
  catppuccin = "catppuccin/nvim",
  tokyonight = "folke/tokyonight.nvim",
  ["rose-pine"] = "rose-pine/neovim",
  tokyodark = "tiagovla/tokyodark.nvim",
  ["night-owl"] = "oxfist/night-owl.nvim",
  NeoSolarized = "Tsuzat/NeoSolarized.nvim",
  Palenight = "drewtempelmeyer/palenight.vim",
  Solarized_highlight = "lifepillar/vim-solarized8",
}

for name, link in pairs(colorschemes) do
  vim.pack.add({{ src = 'https://github.com/' .. link, name = name }})
end

local floatGrous = {
  NormalFloat = { bg = "NONE" },
  FloatBorder = { bg = "NONE" },
}

local NeoSolarized = require("NeoSolarized")
local Solarized_osaka = require("solarized-osaka")

vim.schedule(function ()
    if vim.g.neovide then
    NeoSolarized.setup({ style = "dark", transparent = false,})
    Solarized_osaka.setup({ style = "dark", transparent = false, })
    utils.ConfigHighlightByColorscheme("NeoSolarized", floatGrous)
  else
    NeoSolarized.setup({ style = "dark", transparent = true, })
    Solarized_osaka.setup({ style = "dark", transparent = true, })
  end
end)


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

vim.keymap.set('n','<leader>ctx', function()
   for _, colors in pairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = colors, link = false })
    local new_hl = vim.tbl_extend("force", hl, { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, colors, new_hl)
   end
end, {silent = true, desc = "Transparent mode"})


