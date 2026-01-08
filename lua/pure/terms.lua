local M = {}

-- Using a table to store terminal instances, keyed by command.
-- Each entry will be { buf = buf_id, win = win_id }
local terminals = {}
local func = require('configs.functions')

function M.toggleTerminal(cmd, ratio)
  cmd = cmd or "default"
  ratio = ratio or 0.8

  local term = terminals[cmd]

  -- If the window for this terminal is open, close it.
  if term and term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
    term.win = nil
    return
  end

  -- If a valid buffer for this command exists, re-open it in a new window.
  if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    local buf = term.buf
    local win, _ = func.createWindow(" ", 0.8)
    vim.api.nvim_win_set_buf(win, buf)
    term.win = win
    vim.api.nvim_set_current_win(win)
    vim.cmd("startinsert") -- Re-enter terminal-insert mode.
    return
  end

  -- If we get here, create a new terminal from scratch.
  local cwd
  local current_buf_name = vim.api.nvim_buf_get_name(0)
  if current_buf_name ~= "" and vim.fn.filereadable(current_buf_name) == 1 and vim.bo.buftype == "" then
    cwd = vim.fn.expand("%:p:h")
  else
    cwd = vim.fn.getcwd()
  end

  -- Create a floating window, then switch to it.
  local new_win, _ = func.createWindow(" ", ratio)
  vim.api.nvim_set_current_win(new_win)

  -- Set the working directory for this window only, then open the terminal.
  local escaped_cwd = vim.fn.fnameescape(cwd)
  vim.cmd('lcd ' .. escaped_cwd)

  -- Run the terminal, which will inherit the window-local CWD.
  local final_cmd = "terminal"
  if cmd and cmd ~= "default" then
    final_cmd = final_cmd .. " " .. cmd
  end
  vim.cmd(final_cmd)
  vim.cmd('startinsert')

  -- The :terminal command created a new buffer, so we store it.
  local term_buf = vim.api.nvim_get_current_buf()
  terminals[cmd] = { buf = term_buf, win = new_win }

  -- Set the keymap on the new buffer to close the window.
  vim.keymap.set('n', '<Esc>', function()
    local current_term = terminals[cmd]
    if current_term and current_term.win and vim.api.nvim_win_is_valid(current_term.win) then
      vim.api.nvim_win_close(current_term.win, true)
      current_term.win = nil
    end
  end, { silent = true, buffer = term_buf, desc = "Hide floating terminal" })
end

return M

