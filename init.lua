-- Dashboard
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
      require('Custom_dashboard').drawDashboard()
    end
  end,
})

-- make sure to require the colorscheme first
require('plugins.nightfly')

-- =============================================================================
-- Automatic Recursive Module Loader
-- =============================================================================
-- This script automatically loads all .lua files recursively from the 'lua/' directory.

local lua_path = vim.fn.stdpath('config') .. "/lua/"
local files_to_load = vim.fn.glob(lua_path .. "/**/*.lua", true, true)

for _, file_path in ipairs(files_to_load) do

  --  Get the path relative to the 'lua/' directory.
  local relative_path = string.gsub(file_path, lua_path, "")
  local module_path_no_ext = vim.fn.fnamemodify(relative_path, ':r')

  --  Replace directory separators ('/' or '\') with dots.
  local module_name = string.gsub(module_path_no_ext, "[/\\]", ".")

  -- Safely require the module.
  local ok, err = pcall(require, module_name)
  if not ok then
    vim.notify("Error loading " .. module_name .. ":\n" .. err, vim.log.levels.ERROR)
  end
end

