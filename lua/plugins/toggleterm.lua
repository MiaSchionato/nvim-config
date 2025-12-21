vim.pack.add({ 
    'https://github.com/akinsho/toggleterm.nvim',
})
require("toggleterm").setup{
    float_opts = {
        border = 'rounded'
    },
    direction = 'horizontal',
    persist_size = false,
}
