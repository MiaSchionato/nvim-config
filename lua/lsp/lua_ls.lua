---@brief
---
--- https://github.com/luals/lua-language-server
---
--- Lua language server.
---
--- The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.
---
--- If you primarily use `lua-language-server` for Neovim, and want to provide completions,
--- analysis, and location handling for plugins on runtime path, you can use the following
--- settings.
---
--- ```lua
--- vim.lsp.config('lua_ls', {
---   on_init = function(client)
---     if client.workspace_folders then
---       local path = client.workspace_folders[1].name
---       if
---         path ~= vim.fn.stdpath('config')
---         and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
---       then
---         return
---       end
---     end
---
---     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
---       runtime = {
---         -- Tell the language server which version of Lua you're using (most
---         -- likely LuaJIT in the case of Neovim)
---         version = 'LuaJIT',
---         -- Tell the language server how to find Lua modules same way as Neovim
---         -- (see `:h lua-module-load`)
---         path = {
---           'lua/?.lua',
---           'lua/?/init.lua',
---         },
---       },
---       -- Make the server aware of Neovim runtime files
---       workspace = {
---         checkThirdParty = false,
---         library = {
---           vim.env.VIMRUNTIME
---           -- Depending on the usage, you might want to add additional paths
---           -- here.
---           -- '${3rd}/luv/library'
---           -- '${3rd}/busted/library'
---         }
---         -- Or pull in all of 'runtimepath'.
---         -- NOTE: this is a lot slower and will cause issues when working on
---         -- your own configuration.
---         -- See https://github.com/neovim/nvim-lspconfig/issues/3189
---         -- library = {
---         --   vim.api.nvim_get_runtime_file('', true),
---         -- }
---       }
---     })
---   end,
---   settings = {
---     Lua = {}
---   }
--- })
--- ```
---
--- See `lua-language-server`'s [documentation](https://luals.github.io/wiki/settings/) for an explanation of the above fields:
--- * [Lua.runtime.path](https://luals.github.io/wiki/settings/#runtimepath)
--- * [Lua.workspace.library](https://luals.github.io/wiki/settings/#workspacelibrary)
---

-- This file is now a module that returns a setup function.
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
-- -       runtime = {},
-- -         version = 'LuaJIT',
-- -         path = {
-- -           'lua/?.lua',
-- -           'lua/?/init.lua',
-- -         },
-- -       },
        codeLens = { enable = true },
        hint = { enable = true, semicolon = 'Disable' },
        inlayHint = { enable = true },
        workspace = {
          library = {
            -- vim.api.nvim_get_runtime_file('', true), -- warning: slower
            vim.env.VIMRUNTIME,
          },
        },
      },
    },
-- -   on_init = { function(client)
-- -     if client.workspace_folders then
-- -       local path = client.workspace_folders[1].name
-- -       if
-- -         path ~= vim.fn.stdpath('config')
-- -         and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
-- -       then
-- -         return
-- -       end}
--   }
--
-- -     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
-- -       workspace = {
-- -         checkThirdParty = false,
-- -         library = {
-- -           vim.env.VIMRUNTIME
-- -         }
-- -         -- library = {
-- -         --   vim.api.nvim_get_runtime_file('', true),
-- -         -- }
-- -       }
-- -     })
-- -   end,
-- -   settings = {
-- -     Lua = {}
-- -   }
-- - })
}
end
