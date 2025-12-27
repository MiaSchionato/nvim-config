local M = {}
local mini = require('plugins.mini')

function M.MyTabline()
  local line = ""
  local tabs = vim.api.nvim_list_tabpages()

  for i, tab_id in ipairs(tabs) do
    local is_selected = tab_id == vim.api.nvim_get_current_tabpage()
    local win_id = vim.api.nvim_tabpage_get_win(tab_id)
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ":t")

    if buf_name == "" then
      buf_name = "[No Name]"
    end

    local highlight = is_selected and "%#TabLineSel#" or "%#TabLine#"
    line = line .. highlight .. " " .. i .. " " .. buf_name .. " "
  end

  return line .. "%#TabLineFill#"
end

local zen_mode_enabled = false
function M.toggle_zen_mode(show_notify)
  show_notify = show_notify ~= false -- Default to true if not explicitly false
  zen_mode_enabled = not zen_mode_enabled

  -- Toggle LSP features
  vim.lsp.inlay_hint.enable(not zen_mode_enabled)
  vim.diagnostic.config({
    virtual_text = not zen_mode_enabled
  })

  -- Toggle UI elements
  vim.wo.signcolumn = zen_mode_enabled and 'no' or 'auto'
  vim.wo.relativenumber = not zen_mode_enabled
  vim.wo.number = not zen_mode_enabled
  vim.o.showtabline = zen_mode_enabled and 0 or 1
  vim.o.laststatus = zen_mode_enabled and 0 or 2 -- Assuming 2 is the default for mini.statusline

  if show_notify then
    if zen_mode_enabled then
      vim.notify('Zen Mode Enabled')
    else
      vim.notify('Zen Mode Disabled')
    end
  end
end

-- Dedicated function to apply the dashboard's visual style.
function M.apply_dashboard_style()
  vim.wo.relativenumber = false
  vim.wo.number = false
  vim.wo.signcolumn = 'no'
  vim.o.showtabline = 0
  vim.o.laststatus = 0
end

-- Dedicated function to reset the dashboard's visual style.
function M.reset_dashboard_style()
  vim.wo.relativenumber = true
  vim.wo.number = true
  vim.wo.signcolumn = 'auto'
  vim.o.showtabline = 1
  vim.o.laststatus = 2 -- Assuming 2 is the default for mini.statusline
end


function M.toggle_statusline()
  if vim.o.laststatus == 0 then
    vim.o.laststatus = 2
  else
    vim.o.laststatus = 0
  end
end

function M.toggle_tabline()
    if vim.o.showtabline == 1 then
        vim.o.showtabline = 0
    else
        vim.o.showtabline = 1
    end
end

function M.toggle_number()
  if vim.o.number == true then
    vim.o.number = false
  else
    vim.o.number = true
  end
end

function M.toggle_relativenumber()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

function M.toggle_signcolumn()
  if vim.wo.signcolumn:match('^yes') or vim.wo.signcolumn:match('^auto') then
    vim.wo.signcolumn = 'no'
  else
    vim.wo.signcolumn = 'yes'
  end
end

function M.toggle_diagnostics()
  vim.diagnostic.config({
    virtual_text = not vim.diagnostic.config().virtual_text
  })
end

function M.snippet_jump_next()
  if mini.session.get() then
    return '<Cmd>lua MiniSnippets.session.jump("next")<CR>'
  else
    return '<Right>'
  end
end

function M.snippet_jump_prev()
  if mini.session.get() then
    return '<Cmd>lua MiniSnippets.session.jump("prev")<CR>'
  else
    return '<Right>'
  end
end

function M.snippet_stop()
  if MiniSnippets.session.get() then
    MiniSnippets.session.stop()
  end
  vim.cmd.stopinsert()
end

function M.toggle_inlay_hints()
  vim.lsp.inlay_hint.enable = not vim.lsp.inlay_hint.is_enabled()
end

function M.get_opts(base_opts, desc)
  return vim.tbl_extend("force", base_opts, {desc = desc})
end

function M.minifiles_toggle()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end

function M.create_window(title, ratio)
  local buf = vim.api.nvim_create_buf(false, true)
  local height = math.ceil(vim.o.lines * ratio)
  local width = math.ceil(vim.o.columns * ratio)
  if title == " " then
    title = nil
  end

  local win = vim.api.nvim_open_win(buf, true,{
    relative = "editor",
    width = width,
    height = height,
    row = math.ceil((vim.o.lines - height) / 2),
    col = math.ceil((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = title,
  })

  return win, buf
end

local match_id = {}
function M.toggle_word_highlight()
    local word = vim.fn.expand('<cword>')
    if match_id[word] ~= nil then
        pcall(vim.fn.matchdelete, match_id[word])
        match_id[word] = nil
        vim.fn.setreg("/", "")
    else
        if word == "" then return end

        local pattern = [[\<]] .. word .. [[\>]]
        match_id[word] = vim.fn.matchadd('Search', pattern)
        vim.fn.setreg("/", pattern)
    end
end

-- TODO: Implement git diff toggle
local namespace_id =vim.api.nvim_create_namespace("git-diff")
local diff_active = false

function M.git_diff_toggle()
  if diff_active then
    vim.api.nvim_buf_clear_namespace(0,namespace_id,0,-1)
    diff_active = false
    vim.notify("diff deactivated")
    return
  end

local buf_path = vim.api.nvim_buf_get_name(0)
if buf_path == "" then return end
local file_path = vim.fn.fnamemodify(buf_path, ":h")


local cmd = string.format("git -C %s diff -U0 --no-color -- %s",
vim.fn.shellescape(file_path), -- buff parent dir
vim.fn.shellescape(vim.fn.fnamemodify(buf_path, ":t"))
)

local output = vim.fn.systemlist(cmd)

if not output or #output == 0 then
  vim.notify("Git diff: nothing to show")
  return
end

diff_active = true
vim.notify("Git diff activated")
local current_line = 0

  for i = 1, #output do
    local line = output[i]

    -- local start_line = line:match("^@@%s*%-?%d*,?%d*%s+%+(%d+),?%d*%s*@@")
    local start_line = line:match("^@@.-%+(%d+)")
    if start_line then
      current_line = tonumber(start_line) or 0

    elseif line:sub(1, 1) == "+" and line:sub(1, 3) ~= "+++" then
      vim.api.nvim_buf_set_extmark(0, namespace_id, current_line - 1, 0, {
        line_hl_group = "DiffAdd",
        end_row = current_line, -- covers whole line
      })
      current_line = current_line + 1

    elseif line:sub(1,1) == "-" and line:sub(1, 3) ~= "---" then
      local deleted_text = line:sub(2)
      vim.api.nvim_buf_set_extmark(0, namespace_id, math.max(0, current_line -1), 0, {
        virt_lines = {{{" - " .. deleted_text, "DiffDelete"}}},
        virt_lines_above = true,
      })

    end
  end
end
return M
