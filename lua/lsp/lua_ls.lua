-- This file is a module that returns a setup function.
-- It accepts the language settings augroup to add its own settings.
return function(lang_settings_group)
  -- Add autocommands for Lua-specific editor settings to the shared group
  vim.api.nvim_create_autocmd('FileType', {
    group = lang_settings_group,
    pattern = 'lua',
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.expandtab = true
    end,
  })

  -- Return the LSP configuration table for lua_ls
  ---@type vim.lsp.Config
  return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
      '.emmyrc.json',
      '.luarc.json',
      '.luarc.jsonc',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      'selene.toml',
      'selene.yml',
      '.git',
    },
    settings = {
      Lua = {
        codeLens = { enable = true },
        hint = { enable = true, semicolon = 'Disable' },
        inlayHint = { enable = true },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
          },
        },
      },
    },
}
end
