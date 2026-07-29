-- Raw Neovim 0.12+ config: native LSP API and native vim.pack.

vim.loader.enable() -- byte-compile cache for lua modules, faster startup

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "config.options"
require "config.diagnostics"
require "config.keymaps"

-- ---------------------------------------------------------------------------
-- Plugins (vim.pack): editor tooling, colorschemes, treesitter, Telescope,
-- Mason, which-key, and task running. LSP and diagnostics stay built-in.
-- ---------------------------------------------------------------------------
vim.pack.add {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/Mofiqul/dracula.nvim", name = "dracula" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/ahmedkhalf/project.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/stevearc/overseer.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/kawre/leetcode.nvim" },
}

require "config.colorscheme"
require "config.treesitter"
require "config.project"
require "config.autopairs"
require "config.format"
require "config.telescope"
require "config.mason"
require "config.whichkey"
require "config.overseer"
require "config.devtools"
require "config.leetcode"

-- ---------------------------------------------------------------------------
-- LSP servers
-- Each name below is auto-resolved from lsp/<name>.lua (or after/lsp/<name>.lua
-- for overrides). No nvim-lspconfig required — this is the native 0.11+ mechanism.
-- ---------------------------------------------------------------------------
vim.lsp.enable {
  "lua_ls",
  "dockerls",
  "yamlls",
  "gopls",
  "rust_analyzer",
  "tsc",
}
