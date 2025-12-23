local F = {}

function F.create_window(title, ratio)
  local buf = vim.api.nvim_create_buf(false, true)
  local height = math.ceil(vim.o.lines * ratio)
  local width = math.ceil(vim.o.columns * ratio)

  local win = vim.api.nvim_open_win(buf, true,{
    relative = "editor",
    width = width,
    height = height,
    row = math.ceil((vim.o.lines - height) / 2),
    col = math.ceil((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " ".. title .. " ",
    title_pos = "center"
  })
  return buf, win
end

return F
