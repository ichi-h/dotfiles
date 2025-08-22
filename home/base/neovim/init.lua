-- ####################
--        Keymap
-- ####################

-- Insert mode keymaps
vim.keymap.set('i', 'jj', '<ESC>', { silent = true })

-- Normal mode keymaps
vim.keymap.set('n', '<CR>', 'i<CR><ESC>')
vim.keymap.set('n', '<BS>', 'i<BS><ESC>')
vim.keymap.set('n', '<Space>', 'i<Space><ESC>')
vim.keymap.set('n', 'gr', 'gT')



-- ####################
--   General setting
-- ####################

-- File encodings
vim.opt.fileencodings = 'utf-8'

-- Syntax highlighting
vim.cmd('syntax on')

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Line numbers and cursor line
vim.opt.number = true
vim.opt.cursorline = true

-- Cursor line highlight
vim.cmd([[
  highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=black
]])

vim.opt.guicursor = {
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
}

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Smart indent
vim.opt.smartindent = true

-- Clipboard
vim.opt.clipboard:append('unnamed')

-- Status line
vim.opt.laststatus = 2

-- Command line completion
vim.opt.wildmenu = true

-- Disable bell
vim.opt.belloff = 'all'

-- Cursor movement across lines
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'
