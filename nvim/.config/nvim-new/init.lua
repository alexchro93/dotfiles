vim.loader.enable()

-- Set <space> as the leader key for custom keybindings
vim.g.mapleader = " "

-- Set <space> as the local leader key for buffer-local keybindings
vim.g.maplocalleader = " "

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
vim.o.mouse = "a"

-- Highlight the line the cursor is on
vim.o.cursorline = true

-- Keep at least 10 lines visible above and below the cursor
vim.o.scrolloff = 10

-- Show whitespace characters (tabs, trailing spaces, non-breaking spaces)
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", space = "⋅" }

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
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Automatically update treesitter parsers when the plugin is updated
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  -- Colorscheme
  "https://github.com/catppuccin/nvim",
  -- Nerd font icon support
  "https://github.com/echasnovski/mini.icons",
  -- File type icons (used by many plugins)
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- Shows available keybindings as you type
  "https://github.com/folke/which-key.nvim",
  -- Default LSP server configurations
  "https://github.com/neovim/nvim-lspconfig",
  -- Package manager for LSP servers, formatters, and linters
  "https://github.com/mason-org/mason.nvim",
  -- Declarative tool installer for mason
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  -- Formatter runner with format-on-save support
  "https://github.com/stevearc/conform.nvim",
  -- Unified picker and file explorer UI
  "https://github.com/folke/snacks.nvim",
  -- Diagnostics panel for viewing all errors/warnings
  "https://github.com/folke/trouble.nvim",
  -- Go commands for tests, alternate files, tags, and codegen helpers
  "https://github.com/ray-x/go.nvim",
  -- Enhanced Rust support (auto-configures rust-analyzer, no setup needed)
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") },
  -- Treesitter for syntax highlighting, indentation, and code understanding
  "https://github.com/nvim-treesitter/nvim-treesitter",
  -- LSP progress notifications in the bottom-right corner
  "https://github.com/j-hui/fidget.nvim",
  -- Indent guides with active scope highlighting
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  -- Auto-detect indentation style (tabs vs spaces, width)
  "https://github.com/NMAC427/guess-indent.nvim",
  -- Statusline
  "https://github.com/nvim-lualine/lualine.nvim",
})

-- Set up the colorscheme
vim.cmd.colorscheme("catppuccin-mocha")

-- Configure which-key to use the helix preset (compact, bottom-right)
local wk = require("which-key")
wk.setup({
  preset = "helix",
})

-- Register group labels for leader key prefixes
wk.add({
  { "<leader>c", group = "Code" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>s", group = "Search" },
  { "<leader>u", group = "UI" },
  { "<leader>x", group = "Diagnostics" },
})

-- Configure snacks.nvim picker and file explorer
local lsp_symbols_filter = vim.deepcopy(require("snacks.picker.config.sources").lsp_symbols.filter)
vim.list_extend(lsp_symbols_filter.default, { "Constant" })

require("snacks").setup({
  explorer = { enabled = true },
  picker = {
    enabled = true,
    sources = {
      lsp_references = {
        auto_confirm = false,
      },
      lsp_symbols = {
        filter = lsp_symbols_filter,
      },
    },
  },
  scroll = { enabled = true },
})

-- Set up mason for managing LSP server installations
require("mason").setup()

-- Auto-install LSP servers and tools
require("mason-tool-installer").setup({
  ensure_installed = {
    -- Go formatting and language tooling
    "gofumpt",
    "goimports",
    "golangci-lint",
    "gopls",
    "gomodifytags",
    "gotests",
    -- Lua language server and formatter
    "lua-language-server",
    "stylua",
  },
})

-- Configure lua_ls to recognize the `vim` global for Neovim development
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "Snacks" },
      },
      hint = { enable = false },
      runtime = { version = "LuaJIT" },
      workspace = {
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

-- Enable the Lua language server
vim.lsp.enable("lua_ls")

-- Configure gopls for formatting, stronger analysis, and inline hints
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
      },
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      gofumpt = true,
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = false,
      },
      staticcheck = true,
      usePlaceholders = true,
    },
  },
})

-- Enable the Go language server
vim.lsp.enable("gopls")

-- Enable code lenses using the Neovim 0.12 built-in support
vim.lsp.codelens.enable(true)

local go_augroup = vim.api.nvim_create_augroup("dotfiles-go", { clear = true })

-- Add Go-specific keybindings when editing Go files
vim.api.nvim_create_autocmd("FileType", {
  group = go_augroup,
  pattern = "go",
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    vim.keymap.set("n", "<leader>ga", "<cmd>GoAlt<cr>", vim.tbl_extend("force", opts, { desc = "Go alternate file" }))
    vim.keymap.set("n", "<leader>gb", "<cmd>GoBuild<cr>", vim.tbl_extend("force", opts, { desc = "Go build" }))
    vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<cr>", vim.tbl_extend("force", opts, { desc = "Go add if err" }))
    vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<cr>", vim.tbl_extend("force", opts, { desc = "Go run" }))
    vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>", vim.tbl_extend("force", opts, { desc = "Go test package" }))
    vim.keymap.set(
      "n",
      "<leader>gT",
      "<cmd>GoTestFunc<cr>",
      vim.tbl_extend("force", opts, { desc = "Go test function" })
    )
  end,
})

-- Configure conform.nvim to format files on save
require("conform").setup({
  formatters_by_ft = {
    go = { "goimports", "gofumpt" },
    lua = { "stylua" },
    rust = { "rustfmt" },
  },
  format_on_save = function(bufnr)
    local disabled_filetypes = {}
    if disabled_filetypes[vim.bo[bufnr].filetype] then
      return
    end

    return {
      lsp_format = "fallback",
      timeout_ms = 500,
    }
  end,
})

-- Set up trouble for viewing diagnostics (right-side panel)
require("trouble").setup({
  modes = {
    lsp = {
      win = { position = "right" },
    },
    symbols = {
      filter = {
        ["not"] = { ft = "lua", kind = "Package" },
        any = {
          ft = { "help", "markdown" },
          kind = {
            "Class",
            "Constructor",
            "Constant",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
          },
        },
      },
    },
  },
})

-- Configure keybindings for trouble.nvim
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
vim.keymap.set("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Previous Trouble/Quickfix Item" })
vim.keymap.set("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next Trouble/Quickfix Item" })

-- Show diagnostics for the current line in a floating window
vim.keymap.set("n", "<leader>xd", function()
  vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Line diagnostics" })

-- Configure keybindings for snacks.nvim picker and file explorer
-- Top Pickers & Explorer
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

-- find
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })

-- git
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })

-- gh
vim.keymap.set("n", "<leader>gi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })

-- Grep
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })

-- search
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- LSP
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming" })
vim.keymap.set("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- Configure treesitter: install parsers and enable highlighting
require("nvim-treesitter").setup()
require("nvim-treesitter").install({ "go", "gomod", "gosum", "gowork", "lua", "rust", "vimdoc" })

-- Enable treesitter highlighting for languages with installed parsers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gosum", "gowork", "lua", "rust" },
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Set up fidget for LSP progress notifications
require("fidget").setup()

-- Go-specific editor features
require("go").setup({
  lsp_cfg = false,
})

-- Set up indent guides with scope highlighting
require("ibl").setup()

-- Auto-detect indentation style per file
require("guess-indent").setup()

-- Set up statusline
require("lualine").setup({
  options = {
    theme = "auto",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = {
      "encoding",
      "fileformat",
      "filetype",
      -- Show current indent settings (e.g., "Spaces: 2" or "Tabs: 4")
      {
        function()
          if vim.bo.expandtab then
            return "Spaces: " .. vim.bo.shiftwidth
          else
            return "Tabs: " .. vim.bo.tabstop
          end
        end,
        cond = function()
          return vim.bo.buftype == "" and vim.bo.filetype ~= "netrw"
        end,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Enable gopls inlay hints for Go buffers when the LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = go_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "gopls" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
