local ok, theme = pcall(require, "solarized-osaka")
if ok and theme and vim.g.MY_THEME == "solarized-osaka" then
  if vim.g.neovide then
    theme.setup({transparent = false})
    pcall(vim.cmd.colorscheme, "solarized-osaka")
    local neovide = {
        "FloatBorder",
        "FloatTitle",
        "Pmenu",
        "PmenuBorder",
        "NormalFloat",
    }

    for _, group in ipairs(neovide) do
      local hl = vim.api.nvim_get_hl(0, {name = group, link = false})
      if next(hl) then
        hl.bg = "NONE"  -- Change only the bg, mantain other attributes
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  else
    theme.setup({ transparent = true, })
    pcall(vim.cmd.colorscheme, "solarized-osaka")
  end
end

