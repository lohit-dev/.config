-- Raw Neovim 0.12+ config: native LSP API, native vim.pack, no completion/LSP plugins.

vim.loader.enable() -- byte-compile cache for lua modules, faster startup

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "config.options"
require "config.diagnostics"
require "config.keymaps"

-- ---------------------------------------------------------------------------
-- Plugins (vim.pack): colorschemes, treesitter, Telescope, Mason, which-key.
-- LSP itself, diagnostics, and completion stay built-in — zero plugins there.
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
}

require "config.colorscheme"
require "config.treesitter"
require "config.project"
require "config.autopairs"
require "config.format"
require "config.telescope"
require "config.mason"
require "config.whichkey"

-- ---------------------------------------------------------------------------
-- LSP servers
-- Each name below is auto-resolved from lsp/<name>.lua (or after/lsp/<name>.lua
-- for overrides). No nvim-lspconfig required — this is the native 0.11+ mechanism.
-- ---------------------------------------------------------------------------
vim.lsp.enable {
  "gopls",
  "rust_analyzer",
  "tsc",
}
