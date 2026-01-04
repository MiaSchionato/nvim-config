vim.pack.add({
	{ src = 'https://github.com/bluz71/vim-nightfly-colors',
  name = 'nightfly' }
})
local ok, nightfly = pcall(require, "nightfly")
if ok and nightfly and not vim.g.neovide then
  vim.g.nightflyTransparent = true
end

if vim.g.neovide and ok and nightfly then
  vim.g.nightflyTransparent = false
end
