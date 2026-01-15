local transparencyValue = 0.95
local transparency = true
if vim.g.neovide then
  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 5.0
  vim.g.neovide_floating_corner_radius = 0.6

  vim.g.neovide_window_blurred = false -- Disable blur when window is unfocused
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_opacity = transparencyValue
  vim.g.neovide_normal_opacity = transparencyValue

  -- Set background to ethereal default background color
  vim.schedule(function ()
      vim.api.nvim_set_hl(0, "Normal", { bg = "#060b1e" })
  end)
end
  vim.api.nvim_create_user_command('ToggleTransparency', function()
    if transparency == false then
      vim.g.neovide_opacity = transparencyValue
      vim.g.neovide_normal_opacity = transparencyValue
      transparency = true
    else
      vim.g.neovide_opacity = 1.0
      vim.g.neovide_normal_opacity = 1.0
      transparency = false
    end
  end, {})
