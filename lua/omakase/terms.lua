local M = {}

-- Using a table to store terminal instances, keyed by command.
-- Each entry will be { buf = buf_id, win = win_id }
local terminals = {}
local func = require('omakase.functions')

function M.toggle_terminal(cmd)
  cmd = cmd or "default" -- Use a default key for a generic terminal

  local term = terminals[cmd]

  -- If the window for this terminal is open, close it.
  if term and term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
    term.win = nil
    return
  end

  -- If a valid buffer for this command exists, reuse it.
  if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    local buf = term.buf
    local _, win = func.create_window(" ", 0.8) -- Create a new window for the existing buffer
    vim.api.nvim_win_set_buf(win, buf)
    term.win = win
  else

    -- No valid terminal for this command, so create one.
    local _, new_win = func.create_window(" ", 0.8)

    local old_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(new_win)

    local terminal_command = "terminal"
    if cmd ~= "default" then
      terminal_command = terminal_command .. " " .. cmd
    end
    vim.cmd(terminal_command)

    local new_buf = vim.api.nvim_get_current_buf()

    -- Store the new terminal instance
    terminals[cmd] = { buf = new_buf, win = new_win }

    vim.api.nvim_set_current_win(old_win) -- Restore focus

    -- Set the keymap on the new buffer
    vim.keymap.set('n', '<Esc>', function()
      local current_term = terminals[cmd]
      if current_term and current_term.win and vim.api.nvim_win_is_valid(current_term.win) then
        vim.api.nvim_win_close(current_term.win, true)
        current_term.win = nil
      end
    end, { silent = true, buffer = new_buf, desc = "Hide floating terminal" })
  end

  vim.cmd("startinsert")
end

return M

