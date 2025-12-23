local M = {}
local func = require('omakase.functions')

local function open_and_clean(win,buf,data,path)
  vim.schedule(function()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end

    if data ~= "" and data ~= nil then
      vim.cmd("edit! " .. vim.fn.fnameescape(path .. data))
      vim.cmd("filetype detect")
    end
  end)
end

local function fuzzy_logic(win,buf,temp,path)
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    callback = function()
      local data = ""

      if vim.fn.filereadable(temp) == 1 then
        local f = io.open(temp, "r")
        if f then data = f:read("*all"):gsub("%s+$", "") f:close() end
        os.remove(temp)
      end

      open_and_clean(win,buf,data,path)
    end
  })
end

function M.fuzzy_search(path)
  if path == nil then path = "/Users/mia" end
  local fd = "fd --hidden --type file . --base-directory "

  local buf, win = func.create_window("Fuzzy Search", 0.6)
  local temp = vim.fn.stdpath("cache") .. "/fuzzy_search"
  local cache_dir = vim.fn.stdpath("cache") if vim.fn.isdirectory(cache_dir) == 0 then vim.fn.mkdir(cache_dir, "p") end

  vim.cmd(string.format("terminal %s %s | fzf > %s", fd, path, temp))
  fuzzy_logic(win,buf,temp,path)

  vim.cmd("startinsert")
end

function M.fuzzy_grep(path)
  local temp = vim.fn.stdpath("cache") .. "/grep_selection"
  local cache_dir = vim.fn.stdpath("cache") if vim.fn.isdirectory(cache_dir) == 0 then vim.fn.mkdir(cache_dir, "p") end
  local rg = "rg --column --line-number --no-heading --color=always --smart-case -- . "
  local fzf = "fzf --ansi --delimiter : --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' "

  local buf, win = func.create_window("Fuzzy Grep", 0.8)
  vim.cmd(string.format("terminal %s %s | %s  > %s ", rg, path, fzf, temp))

  fuzzy_logic(win,buf,temp,path)
  vim.cmd("startinsert")
end

return M
