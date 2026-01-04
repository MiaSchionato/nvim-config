local M = {}
vim.pack.add({
	'https://github.com/nvim-mini/mini.nvim',
})

-- completion (load and config native nvim completion)
require('mini.completion').setup()

local function map_expr(lhs, rhs)
  vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = true})
end

map_expr('<tab>', function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
return "<tab>"
end)

map_expr('<S-tab>', function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
return "<S-tab>"
end)

map_expr('<CR>', function()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info().selected == -1 then
      return "<C-n><C-y>"
    end
    return "<C-y>"
  end
  return require('mini.pairs').cr()
end)

-- Indentscope (indentation line)
require('mini.indentscope').setup({
  -- Draw options
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,
    predicate = function(scope) return not scope.body.is_incomplete end,

    -- Symbol priority. Increase to display on top of more symbols.
    priority = 2,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = 'ii',
    object_scope_with_border = 'ai',

    -- Motions (jump to respective border line; if not present - body line)
    goto_top = '[i',
    goto_bottom = ']i',
  },
  -- Options which control scope computation
  options = {
    border = 'both',
    indent_at_cursor = true,
    n_lines = 10000,
    try_as_border = false,
  },
  -- Which character to use for drawing scope indicator
  symbol = '╎',
  -- symbol = '|',
})

-- Mini Notify
require('mini.notify').setup({
  -- Content management
  content = {
    format = nil,
    sort = nil,
  },

  -- Notifications about LSP progress
  lsp_progress = {
    -- Whether to enable showing
    enable = true,

    -- Notification level
    level = 'INFO',

    -- Duration (in ms) of how long last message should be shown
    duration_last = 1000,
  },

  -- Window options
  window = {
    -- Floating window config
    config = {},
    -- Maximum window width as share (between 0 and 1) of available columns
    max_width_share = 0.382,
    -- Value of 'winblend' option
    winblend = 25,
  },
})


-- Mini Snippets
--
require('mini.snippets').setup({
  snippets = {
    require('mini.snippets').gen_loader.from_lang(),
  },
})
require('mini.snippets').start_lsp_server()

return M
