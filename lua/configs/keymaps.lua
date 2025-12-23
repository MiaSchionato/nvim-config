local map = vim.keymap.set
local term = require('omakase.terms')
local mini = require('plugins.mini')
local func = require('configs.functions')
local lsp = vim.lsp.buf
local diag = vim.diagnostic
local opts = {noremap = true, silent = true }
local expr_opts = {expr = true, noremap = true, silent = true }

vim.g.mapleader = ' '

-- SPLIT View
map('n', "<leader>vl", "<C-w>l", func.get_opts(opts,"Windows Movments" ))
map('n', "<leader>vh", "<C-w>h", func.get_opts(opts,"Windows Movments" ))
map('n', "<leader>vj", "<C-w>j", func.get_opts(opts,"Windows Movments" ))
map('n', "<leader>vk", "<C-w>k", func.get_opts(opts,"Windows Movments" ))

-- Basics
map({ 'n', 'v' }, ";", ":")
map({ 'n', 'v' }, ":", ";")
map('n', "Y", "y$", opts)
map('n', "q;", "q:", opts)
map('n', "gl", "$", opts)
map('n', "gh", "0", opts)
map('n', "ge", "G", opts)

map("n", "x", "V", func.get_opts(opts,"Line select (like x on Helix editor)" ))
map("v", "x", "j", func.get_opts(opts,"Line select (like x on Helix editor)" ))
map("n", "z", "V", func.get_opts(opts,"Line select (like x on Helix editor)" ))
map("v", "z", "k", func.get_opts(opts,"Line select (like x on Helix editor)" ))

map("n", "<leader><leader>", "<cmd>so<cr>", opts)

-- Window Tab mappings
map('n', "<leader>wn", "<cmd>tabnew<CR>", func.get_opts(opts, "New Tab" ))
map('n', "<leader>wl", "<cmd>tabnext<CR>", func.get_opts(opts, "Next Tab" ))
map('n', "<leader>wh", "<cmd>tabprevious<CR>", func.get_opts(opts, "Previous Tab" ))
map('n', "<leader>wq", "<cmd>tabclose<CR>", func.get_opts(opts, "Close Tab" ))
map('n', "<leader>wo", "<cmd>tabonly<CR>", func.get_opts(opts, "Close all other Tabs" ))

-- == Files mappings ==
map('n', '<leader>e', func.minifiles_toggle, func.get_opts(opts, 'Toggle Mini Files'))
map('n', "<leader>op",function() MiniFiles.open('/Users/mia/Projects/') end, func.get_opts(opts, "Projects Directory" ))
map('n', "<leader>ol", function() MiniFiles.open("~/Documents/my_devops_journey/Languages") end, func.get_opts(opts, "Languages Directory" ))
map('n', "<leader>oc", function() MiniFiles.open("~/.config/nvim/") end, func.get_opts(opts, "nvim config Directory" ))
map('n', "<leader>oh", function() MiniFiles.open("~/") end, func.get_opts(opts, "Home Directory" ))


-- == Fuzzt Search ==
local fzf = require('omakase.fuzzySearch')
map("n", "<leader>ff",function()fzf.fuzzy_search("/Users/mia/")end, func.get_opts(opts, "Fuzzy Search Home Directory"))
map("n", "<leader>fp",function()fzf.fuzzy_search("Projects/")end, func.get_opts(opts, "Fuzzy Search Projects Directory"))
map("n", "<leader>fn",function()fzf.fuzzy_search(".config/nvim/")end, func.get_opts(opts, "Fuzzy Search Nvim config Directory"))
map("n", "<leader>fl",function()fzf.fuzzy_search("Documents/my_devops_journey/Languages/")end, func.get_opts(opts, "Fuzzy Search Languages Directory"))
map('n', "<leader>fc",function()fzf.fuzzy_search(".config/")end, func.get_opts(opts, "Pick .Config Directory"))
map('n', "<leader>fg", function() fzf.fuzzy_grep("Projects/")end)
map('n', "<leader>fgx", function() fzf.fuzzy_grep(vim.fn.expand('%:p:h'))end)
-- map('n', "<leader>f/", [[<cmd>Pick oldfiles<cr>]], func.get_opts(opts, "Pick oldfiles" ))

-- Pick search
-- map('n', "<leader>sh", "<cmd>Pick help<CR>", func.get_opts(opts, "Pick-search help" ))
-- map('n', "<leader>se", "<cmd>Pick explorer<CR>", func.get_opts(opts, "Pick-search explorer" ))
-- map('n', "<leader>sb", "<cmd>Pick buffers<CR>", func.get_opts(opts, "Pick-search buffers" ))
-- map('n', "<leader>s?", "<cmd>Pick keymaps<CR>", func.get_opts(opts, "Pick-search keymaps" ))
-- map('n', "<leader>?", "<cmd>Pick keymaps<CR>", func.get_opts(opts, "Pick-search keymaps" ))
-- map('n', "<leader>so", "<cmd>Pick options<CR>", func.get_opts(opts, "Pick-search options" ))
-- map('n', "<leader>sd", "<cmd>Pick diagnostic<CR>", func.get_opts(opts, "Pick-search diagnostic" ))
-- map('n', "<leader>s\'", "<cmd>Pick registers<CR>", func.get_opts(opts, "Pick-search registers" ))
-- map('n', "<leader>sg", "<cmd>Pick buf_lines<CR>", func.get_opts(opts, "Pick-search buffer with lines grep" ))
-- map('n', "<leader>s;", "<cmd>Pick history<CR>", func.get_opts(opts, "Pick-search command history" ))

-- == Visual mode mappings ==
map('v', "<leader>s", [[:s/\%V]], func.get_opts(opts, "Substitute selected" ))
map('v', "<leader>n", [[:norm]], func.get_opts(opts, "Norm mode" ))
map('v', "<leader>v", [[:s/\v]], func.get_opts(opts, "Very magic mode" ))
map('n', "vv", 'viw', func.get_opts(opts, "Select line" ))

-- == Normal mode mappings ==
map('n', "<leader>cl", "<cmd>nohlsearch<CR>", func.get_opts(opts, "Clear search highlights" ))
map('n', "<leader>p", '"*p', func.get_opts(opts, "Clipboard Paste" ))
map("x", "<leader>p", [["_dP]])
map({ 'n', "v" }, "<leader>y", '"*y', func.get_opts(opts, "Clipboard Paste" ))
map({ 'n', "v" },"<leader>dd", '"_d', func.get_opts(opts, "Delete without yanking" ))
map('n', "<leader>n", 'viw*n', func.get_opts(opts, "Delete without yanking" ))

-- == Insert mode mappings ==
map('i', "jf", "<Esc>", func.get_opts(opts, "Next buffer" ))


-- Buffer navigation
map('n', "<leader>bn", "<cmd>bnext<CR>", func.get_opts(opts, "Next buffer" ))
map('n', "<leader>bp", "<cmd>bprevious<CR>", func.get_opts(opts, "Previous buffer" ))
map('n', "<leader>bq", "<cmd>bdelete<CR>", func.get_opts(opts, "Delete buffer" ))
map('n', "<leader>bv", "<cmd>buffers<CR>", func.get_opts(opts, "View buffer" ))
map('n', "<leader>bo", "<cmd>%bd|e#<cr>", func.get_opts(opts, "Close all buffers and reload previous" ))

-- Splitting & Resizing
map('n', "<leader>v", "<cmd>vsplit<CR>", func.get_opts(opts, "Split window vertically" ))
map('n', "<leader>h", "<cmd>split<CR>", func.get_opts(opts, "Split window horizontally" ))
map('n', "<leader>+", "<cmd>resize +2<CR>", func.get_opts(opts, "Increase window height" ))
map('n', "<leader>-", "<cmd>resize -2<CR>", func.get_opts(opts, "Decrease window height" ))
map('n', "<leader><", "<cmd>vertical resize -2<CR>", func.get_opts(opts, "Decrease window width" ))
map('n', "<leader>>", "<cmd>vertical resize +2<CR>", func.get_opts(opts, "Increase window width" ))

-- Move lines up/down
map('n', "<up>", "<cmd>m .-2<CR>==", func.get_opts(opts, "Move line up" ))
map('n', "<down>", "<cmd>m .+1<CR>==", func.get_opts(opts, "Move line down" ))
map('v', "<up>", "<cmd>m '<-2<CR>gv=gv", func.get_opts(opts, "Move selection up" ))
map('v', "<down>", "<cmd>m '>+1<CR>gv=gv", func.get_opts(opts, "Move selection down" ))

-- Better indenting in visual mode
map('v', "<", "<gv", func.get_opts(opts, "Indent left and reselect" ))
map('v', ">", ">gv", func.get_opts(opts, "Indent right and reselect" ))

-- Better J behavior
map('n', "J", "mzJ`z", func.get_opts(opts, "Join lines and keep cursor position" ))

-- ==== Terminal mappings ===
map('n', '<leader>tt', term.toggle_terminal, func.get_opts(opts, 'Toggle bottom terminal'))
map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', func.get_opts(opts, 'Toggle floating Terminal'))
map('n', '<leader>tb', '<cmd>ToggleTerm direction=tab<CR>', func.get_opts(opts, 'Toggle terminal on another tab'))
map('t', 'qq', [[<C-\><C-n>]], func.get_opts(opts, 'Close on terminal mode'))


-- LSP actions
map('n', 'K', lsp.hover, func.get_opts(opts, 'LSP Hover' ))
map('n', 'gd', lsp.definition, func.get_opts(opts, 'LSP Definition' ))
map('n', 'gr', lsp.references, func.get_opts( opts,'LSP References' ))
map('n', '<leader>la', lsp.code_action, func.get_opts(opts, 'LSP Code Action' ))
map('n', '<leader>lr', lsp.rename, func.get_opts( opts,'LSP Rename' ))
map("i", "<up>", lsp.signature_help, func.get_opts( opts,'C-h is set as left on my wezterm config' ))
map("n", "<leader>ws",  lsp.workspace_symbol, func.get_opts(opts,' Search workspace symbols') )
map("n", "<leader>d", diag.open_float, func.get_opts(opts,'Open diagnostic\'s floating Window'))

-- Diagnostics
map("n", "[d",  diag.get_prev)
map("n", "]d", diag.get_next)
map('n', '<leader>ld', func.toggle_diagnostics, func.get_opts(opts, 'Toggle Diagnostics' ))

-- Zen Mode
map('n', '<leader>lz', func.toggle_zen_mode, func.get_opts(opts, 'Toggle Zen Mode' ))

-- Toggle UI elements
map('n', '<leader>ls', func.toggle_statusline, func.get_opts(opts,'Toggle Statusline' ))
map('n', '<leader>lt', func.toggle_tabline, func.get_opts(opts,'Toggle Tabline'))
map('n', '<leader>lc', func.toggle_signcolumn, func.get_opts(opts,'Toggle Signcolumn'))
map('n', '<leader>lw', '<cmd>set wrap!<cr>',func.get_opts(opts,'Toggle Signcolumn'))
map('n', '<leader>li', func.toggle_inlay_hints, func.get_opts(opts,'Toggle Inlay Hints'))

 -- toggle number / relative line number 
map({ 'n', 'v' }, '<leader>lrn', func.toggle_relativenumber, func.get_opts(opts, ' Toggle relativenumber'))
map({ 'n', 'v' }, '<leader>ln', func.toggle_number, func.get_opts(opts, 'Toggle relativenumber'))

-- Snippet 
map('i', '<Right>', func.snippet_jump_next, func.get_opts(expr_opts, 'Jump to the next arg on snippets'))
map('i', '<Left>', func.snippet_jump_prev, func.get_opts(expr_opts, ' Jump to the previous arg on snippets'))
map('i', '<Esc>', func.snippet_stop, func.get_opts(opts, 'Close snippet'))

-- debug
map({ 'v', 'n' }, '<leader>in', ':Inspect<cr>')
map('v', '<leader>ldb', 'y:lua print(<C-r>")<cr>')
map('n', '<leader>cn', ':colorscheme nightfly<cr>')
map( "n", "<leader>tx", term.toggle_terminal)

-- teste
