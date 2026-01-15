-- The only few plugins on this config

vim.pack.add({
  {src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main'},
  -- {src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'master'}
})

local treesitter = require('nvim-treesitter')
treesitter.setup({
  ensure_installed = {
  "c",
  "cpp",
  "cs",
  "lua",
  "json",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "go",
  "bash",
  "dockerle",
  "python",
},
  sync_install = false,
  auto_install = false,

  highlight = {
    enable = true,
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = true,
    indent = {enable = true},
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["iq"] = "@string.inner",
        ["aq"] = "@string.outer",

        ["if"] = "@function.inner",
        ["af"] = "@function.outer",

        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
      },
    },
  }
})

