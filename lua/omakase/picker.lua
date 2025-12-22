local M = {}

function M.picker()
  local cmd = "fd --type f --strip-cwd-prefix --hidden --exclude .git"
  local files = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error running fd command, make sure is installed and in your path.", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, files)

  local width = math.ceil(vim.o.columns * 0.4)
  local height = 15
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = vim.o.lines - height -3,
    col = 0, -- left corner
    style = "minimal",
    border = "rounded",
    title = "Picker",
    title_pos = "left",
  })

  local opts = {buffer = buf, silent = true}
  vim.keymap.set('n', '<CR>', function ()
    local file = vim.api.nvim_get_current_line()
    vim.api.nvim_win_close(win, true)
    if file ~= " " then vim.cmd('edit ' .. file) end
  end, opts)
  vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, opts)
  -- vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, opts)

  vim.api.nvim_set_hl(0, "PickerBorder", { link = "FloatBorder" })
end
return M
