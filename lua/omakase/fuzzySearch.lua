local M = {}
local func = require('configs.functions')
local cache_dir = vim.fn.stdpath("cache") if vim.fn.isdirectory(cache_dir) == 0 then vim.fn.mkdir(cache_dir, "p") end

function M.fuzzy_logic(opts)
  local win,buf = func.create_window(opts.title, opts.ratio)
  local temp = vim.fn.stdpath("cache") .. "/opts_run"
  vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buf})
  vim.cmd(string.format("terminal %s > %s", opts.cmd, temp))

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    callback = function()
      local data = ""

      if vim.fn.filereadable(temp) == 1 then
        local f = io.open(temp, "r")
        if f then data = f:read("*all"):gsub("%s+$", "") f:close() end
        os.remove(temp)
      end

      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end

        if data ~= "" and vim.fn.filereadable(data) ~= nil then
          opts.callback(data)
        else
            vim.cmd("stopinsert")
        end
      end)
    end
  })
  vim.cmd("startinsert")
end

function M.fuzzy_search(path)
  if path == nil then path = "/Users/mia/" end
  local fd = "fd --hidden --type file . --strip-cwd-prefix --base-directory  "
  local fzf = "fzf --keep-right --tiebreak=end"

  M.fuzzy_logic({
    title = "Fuzzy Search",
    ratio = 0.6,
    cmd = string.format("%s %s | %s", fd, path, fzf),
    callback = function(selection)
      vim.cmd("edit! " .. vim.fn.fnameescape(path .. selection))
      vim.cmd("filetype detect")
    end

  })
end


function M.fuzzy_grep(path)
  local rg = "rg --column --line-number --no-heading --color=always --smart-case -- . "
  local fzf = "fzf --ansi --delimiter : --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' --preview-window 'up,60\\%,border-bottom,+{2}+3/3'"

  M.fuzzy_logic({
    title = "Fuzzy Grep",
    ratio = 0.8,
    cmd = string.format("%s %s | %s",rg,path,fzf),
    callback = function(selection)
      local full_path, line, col = selection:match("^([^:]+):(%d+):(%d+)")
      if full_path and line and col then
        vim.cmd("edit! " .. vim.fn.fnameescape(full_path))
        vim.api.nvim_win_set_cursor(0, {tonumber(line),tonumber(col)})
      end
      vim.cmd("filetype detect")
    end
  })
end

function M.fuzzy_help()
  local doc_path = vim.fn.expand("$VIMRUNTIME/doc/")

  M.fuzzy_logic({
    title = "Fuzzy help",
    ratio = 0.6,
    cmd = string.format("ls %s | fzf", doc_path),
    callback = function (selection)
      vim.cmd("help " .. vim.fn.fnameescape(selection))
      vim.cmd("filetype detect")
    end
  })
end

function M.fuzzy_git()
  local path = vim.fn.expand("%:p:h")

  local fzf = "fzf --ansi --preview 'git show --color=always {1}' --preview-window 'up,60\\%,wrap,border-bottom'"
  local git = "git log --oneline --color=always "

  M.fuzzy_logic({
    title = "Fuzzy Git log",
    ratio = 0.8,
    cmd = string.format("cd %s && %s | %s",path, git, fzf),
    callback = function (selection)
      vim.cmd(string.format("edit %s", vim.fn.fnameescape(selection)))
    end
  })
end


-- TODO: finish this func
function M.fuzzy_git_grep()
  local temp = vim.fn.stdpath("cache") .. "/git_log"
  vim.cmd(string.format("!  git log --oneline > %s", temp))
  M.fuzzy_grep(temp)
end

function M.fuzzy_jump()
  -- Get tablet contet
  local jumplist = vim.fn.getjumplist()
  local jumps = {}
    for _, jump in ipairs(jumplist[1]) do
      local path = vim.api.nvim_buf_get_name(jump.bufnr)
      if path ~= "" then
        table.insert(jumps,string.format("%s:%d:%d", path, jump.lnum, jump.col))
      end
    end

  -- Write to temp file
  local temp = vim.fn.stdpath("cache") .. "/Jump_list"
  local f = io.open(temp, "w")
  if f then
    f:write(table.concat(jumps, "\n"))
    f:close()
  end

  local fzf = "fzf --ansi --delimiter : --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' --preview-window 'up,60\\%,border-bottom,+{2}+3/3'"
  M.fuzzy_logic({
    title = "fuzzy jumps",
    ratio = 0.8,
    cmd = string.format("cat %s | %s", temp, fzf),
    callback = function (selection)
      local full_path, line, col = selection:match("^([^:]+):(%d+):(%d+)")
      vim.cmd("edit! " .. vim.fn.fnameescape(full_path))
      if full_path and line and col then
        vim.api.nvim_win_set_cursor(0, {tonumber(line),tonumber(col)})
        vim.cmd("filetype detect")
      end
    end
  })
end


function M.fuzzy_buffers()
  -- Get table contet
  local buffer_list = vim.api.nvim_list_bufs()
  local buffers = {}
  for _, bufnr in ipairs(buffer_list) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local full_path = vim.api.nvim_buf_get_name(bufnr)
      local short_path = vim.fn.fnamemodify(full_path, ":.")
      table.insert(buffers, short_path)
    end
  end

  -- Write to temp file
  local temp = vim.fn.stdpath("cache") .. "/buffer_list"
  local f = io.open(temp, "w")
  if f then
    f:write(table.concat(buffers, "\n"))
    f:close()
  end

  M.fuzzy_logic({
    title = "Fuzzy buffers",
    ratio = 0.7,
    cmd = string.format("cat %s | fzf --keep-right --tiebreak=end", temp),
    callback = function (selection)
        vim.cmd("edit " .. vim.fn.fnameescape(selection))
        vim.cmd("filetype detect")
    end
  })

end

function M.fuzzy_oldfiles()
  -- Get table content
  local oldfiles = vim.tbl_filter(function (f)
    return vim.fn.filereadable(f) == 1
  end, vim.v.oldfiles)

  -- Write table content on temp file
  local temp = vim.fn.stdpath("cache") .. "/oldfiles_list"
  local f = io.open(temp, "w")
  if f then
    f:write(table.concat(oldfiles, "\n"))
    f:close()
  end

  -- Handle to the logic function
  M.fuzzy_logic({
      title = "Oldfiles",
      ratio = 0.7,
      cmd = string.format("cat %s | fzf",temp),
      callback = function(selection)
        vim.cmd("edit " .. vim.fn.fnameescape(selection))
        vim.cmd("filetype detect")
      end
    })

end
return M
