local M = {}

local term_buf = nil
local term_win = nil

function M.toggle_terminal()
  -- If buffer exists and the window is open; hide it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  -- If buffer do not exists; create new

  if term_buf == nil or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false,true) -- listed, scratch
    vim.keymap.set('n', '<Esc>', function()
      if term_win and vim.api.nvim_win_is_valid(term_win) then
          vim.api.nvim_win_close(term_win, true)
          term_win = nil
      end
    end, {silent = true, buffer = term_buf, desc = "Hide floating terminal when in normal mode"})
  end

  local width = math.ceil(vim.o.columns * 0.8)
  local height = math.ceil(vim.o.lines * 0.8)

  term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.ceil((vim.o.columns - width)/2),
    row = math.ceil((vim.o.lines - height)/2),
    style = "minimal",
    border = "rounded",
  })

  -- create shell instance when new buffer
  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.fn.termopen(os.getenv("SHELL") or "bash")
  end

  vim.cmd("startinsert")
end
return M

