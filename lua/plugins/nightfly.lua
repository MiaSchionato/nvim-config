local hi = vim.api.nvim_set_hl
vim.pack.add({
  {
	src = 'https://github.com/bluz71/vim-nightfly-colors',
	name = 'nightfly',
  }
})
vim.cmd.colorscheme("nightfly")

-- Defaults
hi(0, "Normal", { bg = "none" })
hi(0, "NormalNC", { bg = "none" })
hi(0, "EndOfBuffer", { bg = "none" })

-- Columns
hi(0, "LineNr", { bg = "none", fg = '#82AAFF' }) -- numberline
hi(0, "SignColumn", { bg = "none" })
hi(0, "NonText", { fg = "#82AAFF", bold = true })

-- Floating window's 
hi(0, "NormalFloat", { bg = "none" })
hi(0, "FloatBorder", { bg = "none" , fg = '#82AAFF'})
hi(0, "FloatTitle", { bg = "none", fg = '#AFD4FB' })

-- tabview
hi(0, 'TabLine', { bg = 'none', fg = '#82AAFF', bold = true }) -- Active
hi(0, 'TabLineSel', { bg = 'none', fg = '#AFD4FB' }) -- inactive
hi(0, 'TabLineFill', { bg = 'none' }) -- tabline bg

-- lsp
hi(0, 'DiagnosticSignWarn', { bg = 'none', fg ="#e0af68" })
hi(0, 'Pmenu', { bg = 'none', fg = '#82AAFF' })
hi(0, 'PmenuSbar', { bg = 'none' })
hi(0, 'PmenuThumb', { bg = 'none' })

-- Indent
hi(0, 'MiniIndentscopeSymbol', { fg = '#82AAFF' }) -- tabline bg

-- Pick
hi(0, 'MiniPickNormal', { bg = 'none',})
hi(0, 'MiniPickBorder', { bg = 'none',})
hi(0, 'MiniPickBorderText', { bg = 'none',})
hi(0, 'MiniPickMatchCurrent', { fg = '#82AAFF',})
hi(0, 'MiniPickPreviewLine', { fg = '#82AAFF',})

-- Mini Files
hi(0, 'MiniFilesTitle', {bg = 'none'})
hi(0, 'MiniFilesTitleFocused', {bg = 'none', fg = '#82AAFF',})
