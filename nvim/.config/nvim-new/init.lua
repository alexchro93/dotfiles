vim.loader.enable()

-- Set <space> as the leader key for custom keybindings
vim.g.mapleader = ' '

-- Set <space> as the local leader key for buffer-local keybindings
vim.g.maplocalleader = ' '

-- Enable nerd font icons (requires a patched font in your terminal)
vim.g.have_nerd_font = true

-- Case-insensitive searching unless the query contains an uppercase letter
vim.o.ignorecase = true

-- Automatically switches to case-sensitive search if a capital letter is used
vim.o.smartcase = true

-- Enables 24-bit RGB colors in the terminal
vim.opt.termguicolors = true

-- Show line numbers
vim.o.number = true

-- Enable mouse mode (useful for resizing splits, etc.)
vim.o.mouse = 'a'

-- Highlight the line the cursor is on
vim.o.cursorline = true

-- Keep at least 10 lines visible above and below the cursor
vim.o.scrolloff = 10

-- Automatically reload files when changed externally
vim.o.autoread = true

-- Number of spaces that a <Tab> character represents
vim.opt.tabstop = 2

-- Number of spaces to use for each step of automatic indentation
vim.opt.shiftwidth = 2

-- Number of spaces that a <Tab> counts for during editing operations
vim.opt.softtabstop = 2

-- Converts tabs into spaces when typing
vim.opt.expandtab = true

-- Automatically inserts an extra level of indentation in some cases
vim.opt.smartindent = true

-- Makes <Tab> insert 'shiftwidth' number of spaces at the start of a line
vim.opt.smarttab = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.pack.add({
  -- Colorscheme
  'https://github.com/catppuccin/nvim',
  -- Nerd font icon support
  'https://github.com/echasnovski/mini.icons',
  -- Shows available keybindings as you type
  'https://github.com/folke/which-key.nvim',
  -- Default LSP server configurations
  'https://github.com/neovim/nvim-lspconfig',
  -- Package manager for LSP servers, formatters, and linters
  'https://github.com/mason-org/mason.nvim',
  -- Declarative tool installer for mason
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  -- Diagnostics panel for viewing all errors/warnings
  'https://github.com/folke/trouble.nvim',
})

vim.cmd.colorscheme('catppuccin-mocha')

-- Configure which-key to use the helix preset (compact, bottom-right)
require('which-key').setup({
  preset = 'helix',
})

-- Set up mason for managing LSP server installations
require('mason').setup()

-- Auto-install LSP servers and tools
require('mason-tool-installer').setup({
  ensure_installed = {
    'lua-language-server',
    'stylua',
  },
})

-- Configure lua_ls to recognize the `vim` global for Neovim development
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

-- Enable the Lua language server
vim.lsp.enable('lua_ls')

-- Set up trouble for viewing diagnostics (right-side panel)
require('trouble').setup({
  win = {
    position = 'right',
  },
})

-- Toggle diagnostics panel for the current buffer
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer diagnostics' })

-- Toggle diagnostics panel for the whole workspace
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Workspace diagnostics' })

