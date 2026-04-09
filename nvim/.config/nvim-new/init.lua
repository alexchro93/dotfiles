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

-- Show whitespace characters (tabs, trailing spaces, non-breaking spaces)
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', space = '⋅' }

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

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Automatically update treesitter parsers when the plugin is updated
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  -- Colorscheme
  'https://github.com/catppuccin/nvim',
  -- Nerd font icon support
  'https://github.com/echasnovski/mini.icons',
  -- File type icons (used by many plugins)
  'https://github.com/nvim-tree/nvim-web-devicons',
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
  -- Enhanced Rust support (auto-configures rust-analyzer, no setup needed)
  { src = 'https://github.com/mrcjkb/rustaceanvim', version = vim.version.range('^9') },
  -- Treesitter for syntax highlighting, indentation, and code understanding
  'https://github.com/nvim-treesitter/nvim-treesitter',
  -- LSP progress notifications in the bottom-right corner
  'https://github.com/j-hui/fidget.nvim',
  -- Indent guides with active scope highlighting
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  -- Auto-detect indentation style (tabs vs spaces, width)
  'https://github.com/NMAC427/guess-indent.nvim',
  -- Statusline
  'https://github.com/nvim-lualine/lualine.nvim',
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

-- Configure treesitter: install parsers and enable highlighting
require('nvim-treesitter').setup()
require('nvim-treesitter').install({ 'rust', 'lua', 'vimdoc' })

-- Enable treesitter highlighting for Rust and Lua
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'lua' },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Set up fidget for LSP progress notifications
require('fidget').setup()

-- Set up indent guides with scope highlighting
require('ibl').setup()

-- Auto-detect indentation style per file
require('guess-indent').setup()

-- Set up statusline
require('lualine').setup({
  options = {
    theme = 'auto',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      -- Show current indent settings (e.g., "Spaces: 2" or "Tabs: 4")
      {
        function()
          if vim.bo.expandtab then
            return 'Spaces: ' .. vim.bo.shiftwidth
          else
            return 'Tabs: ' .. vim.bo.tabstop
          end
        end,
        cond = function()
          return vim.bo.buftype == '' and vim.bo.filetype ~= 'netrw'
        end,
      },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

