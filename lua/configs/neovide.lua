if vim.g.neovide then

  vim.g.neovide_opacity = 0.9
  vim.g.neovide_normal_opacity = 1
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_corner_radius = 0.6
  vim.o.winblend = 20
  vim.o.pumblend = 20
  vim.g.neovide_window_blurred = false
  -- vim.g.transparency = 0.85
  -- vim.g.neovide_background_color = "#011627" .. string.format("%x", math.floor(255 * vim.g.neovide_opacity))
  -- vim.g.neovide_background_color = "#001419" .. string.format("%x", math.floor(255 * vim.g.neovide_opacity))
  -- vim.g.neovide_fullscreen = tru
  -- vim.g.neovide_macos_simple_fullscreen = .. true
  --
    -- vim.g.neovide_show_border = false
    vim.g.neovide_floating_shadow = false
    -- vim.g.neovide_floating_z_height = 10
    -- vim.g.neovide_light_angle_degrees = 45
    -- vim.g.neovide_light_radius = 5
end
