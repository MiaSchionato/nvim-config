vim.pack.add({
  { src = 'https://github.com/stevearc/oil.nvim', name = 'oil' }
})
require('oil').setup({
  
  columns = {
    'icon',
    'permissions',
    'size',
    'mtime',
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["H"] = "actions.parent",
    ["L"] = "actions.select",
    ["<leader>e"] = "actions.close",
    ["q"] = "actions.close",
    ["P"] = "actions.preview",
    ["R"] = "actions.refresh",
  },
})
