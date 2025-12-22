local o = vim.opt
-- Tab display settings
o.showtabline = 1  -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
o.tabline = "%!v:lua.require('configs.functions').MyTabline()"
o.statusline = "%!v:lua.require('omakase.statusline').MyStatusLine()"

-- Basic settings
o.number = true                              -- Line numbers
o.relativenumber = true                      -- Relative line numbers
o.cursorline = false                          -- Highlight current line
o.winborder = "rounded"
o.wrap = false
o.list = true
o.listchars:append({ extends = "⟩", precedes = "⟨" })

-- Indentation
o.tabstop = 4                                -- Tab width
o.shiftwidth = 4                             -- Indent width
o.softtabstop = 4                            -- Soft tab stop
o.expandtab = true                           -- Use spaces instead of tabs
o.smartindent = true                         -- Smart auto-indenting
o.autoindent = true                          -- Copy indent from current line

-- Search settings
o.ignorecase = true                          -- Case insensitive search
o.smartcase = true                           -- Case sensitive if uppercase in search
o.hlsearch = false                           -- Don't highlight search results 
o.incsearch = true                           -- Show matches as you type

-- Visual settings
o.termguicolors = true                       -- Enable 24-bit colors
o.showmatch = true                           -- Highlight matching brackets
o.cmdheight = 0                              -- Command line height
o.completeopt = "menuone,noinsert,noselect"  -- Completion options 
o.showmode = false                           -- Don't show mode in command line 
o.pumheight = 10                             -- Popup menu height 
o.pumblend = 10                              -- Popup menu transparency 
o.winblend = 0                               -- Floating window transparency 
o.conceallevel= 0                           -- Don't hide markup 
o.concealcursor = ""                         -- Don't hide cursor line markup 
o.lazyredraw = true                          -- Don't redraw during macros
o.signcolumn = "auto"                        -- Show signcolumn automatically

-- File handling
o.undofile = true                            -- Persistent undo
o.undodir = vim.fn.expand("~/.config/nvim/undodir")  -- Undo directory
o.updatetime = 300                           -- Faster completion
o.timeoutlen = 500                           -- Key timeout duration
o.ttimeoutlen = 0                            -- Key code timeout
o.autoread = true                            -- Auto reload files changed outside vim
o.autowrite = false                          -- Don't auto save

-- Behavior settings
o.hidden = true                              -- Allow hidden buffers
o.errorbells = false                         -- No error bells
o.backspace = "indent,eol,start"             -- Better backspace behavior
o.autochdir = false                          -- Don't auto change directory
o.iskeyword:append("-")                      -- Treat dash as part of word
o.path:append("**")                          -- include subdirectories in search
o.wildignore:append("*/node_modules/*", "*/.git/*", "*/tmp/*", "*/dist/*", "*/build/*") -- ignore folders
o.selection = "exclusive"                    -- Selection behavior
o.mouse = ""                                -- Enable mouse support
o.modifiable = true                          -- Allow buffer modifications


-- Split behavior
o.splitbelow = true                          -- Horizontal splits go below
o.splitright = true                          -- Vertical splits go right

-- Performance improvements
o.redrawtime = 10000
o.maxmempattern = 20000

