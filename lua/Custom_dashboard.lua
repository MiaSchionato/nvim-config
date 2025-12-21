local M = {}
-- Require the user's custom functions module.
local custom_functions = require('configs.functions')

-- Create a dedicated augroup for the dashboard to keep autocommands organized.
local dashboard_augroup = vim.api.nvim_create_augroup('DashboardGroup', { clear = true })

-- Autocommand to run when entering the dashboard buffer.
vim.api.nvim_create_autocmd('FileType', {
  group = dashboard_augroup,
  pattern = 'dashboard',
  callback = function(args)
    -- Defer the call to let all other startup autocommands finish first.
    vim.defer_fn(custom_functions.apply_dashboard_style, 10)

    -- Set buffer-local keymaps immediately.
    local opts = { buffer = args.buf, silent = true, nowait = true }
    vim.keymap.set('n', 'n', ':enew<CR>', opts)
    vim.keymap.set('n', 'q', ':qa<CR>', opts)
    vim.keymap.set('n', 'u', vim.pack.update, opts)
  end,
})

-- Autocommand to run when leaving the dashboard buffer.
vim.api.nvim_create_autocmd('BufLeave', {
  group = dashboard_augroup,
  pattern = 'dashboard',
  callback = function()
    -- Defer the reset as well to ensure it runs after other events.
    vim.defer_fn(custom_functions.reset_dashboard_style, 10)
  end,
})

function M.drawDashboard()
  local buf = vim.api.nvim_create_buf(false, true)
  local header = {
    "",
    "   _   _  ____   ___  __     __ ___  __  __ ",
    "  | \\ | ||  __| / _ \\ \\ \\   / /|_ _||  \\/  |",
    "  |  \\| || |__ | | | | \\ \\ / /  | | | |\\/| |",
    "  | |\\  ||  __|| |_| |  \\ V /   | | | |  | |",
    "  |_| \\_||____| \\___/    \\_/   |___||_|  |_|",
    "",
    "       [n] New File    [q] Quit    [u] Update",
    "",
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, header)

  -- Setting the filetype triggers the 'FileType' autocommand above.
  vim.bo[buf].filetype = 'dashboard'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].buftype = 'nofile'

  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_cursor(0, { 8, 0 })
end

return M
