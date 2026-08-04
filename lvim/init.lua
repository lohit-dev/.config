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
  { src = "https://github.com/catgoose/nvim-colorizer.lua" },
  { src = "https://github.com/sainnhe/gruvbox-material" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/sainnhe/everforest" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  -- matching lohit/.zsh syntax-themes/ (tokyo_night, cyberpunk, nord)
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/taigrr/cyberpunk.nvim" },
  { src = "https://github.com/gbprod/nord.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/windwp/nvim-autopairs" },
  { src = "https://github.com/ahmedkhalf/project.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  -- friendly-snippets is just JSON snippet data -- nvim-snippets is what
  -- actually reads it and expands it via vim.snippet. See config.snippets.
  { src = "https://github.com/garymjr/nvim-snippets" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/b0o/SchemaStore.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/axelvc/template-string.nvim" },
  { src = "https://github.com/stevearc/overseer.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/numToStr/Comment.nvim" },
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/kawre/leetcode.nvim" },
  { src = "https://github.com/olexsmir/gopher.nvim" },
  -- rustaceanvim manages the rust-analyzer client itself (ftplugin/rust.lua);
  -- it must NOT also be started through vim.lsp.enable, see config.rustaceanvim.
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range "^9" },
  { src = "https://github.com/ALT-F4-LLC/notion.nvim" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/refractalize/oil-git-status.nvim" },
  { src = "https://github.com/benomahony/oil-git.nvim" },
  { src = "https://github.com/JezerM/oil-lsp-diagnostics.nvim" },
}

-- vim.g.rustaceanvim must be set before any rust buffer opens (rustaceanvim
-- is a ftplugin), so this goes right after vim.pack.add, ahead of everything else.
require "config.rustaceanvim"

require "config.colorscheme"
require "config.colorizer"
require "config.fidget"
require "config.treesitter"
require "config.markdown"
require "config.project"
require "config.autopairs"
require "config.format"
require "config.telescope"
require "config.mason"
require "config.whichkey"
require "config.overseer"
require "config.devtools"
require "config.leetcode"
require "config.gopher"
require "config.notion"
require "config.copilot"
require "config.copilot_chat"
require "config.snippets"
require "config.completion"
require "config.oil"

-- ---------------------------------------------------------------------------
-- LSP servers
-- Each name below is auto-resolved from lsp/<name>.lua (or after/lsp/<name>.lua
-- for overrides). No nvim-lspconfig required — this is the native 0.11+ mechanism.
-- rust_analyzer is deliberately absent here: rustaceanvim starts and owns
-- that client itself (see config.rustaceanvim).
-- ---------------------------------------------------------------------------
vim.lsp.enable {
  "lua_ls",
  "dockerls",
  "yamlls",
  "jsonls",
  "taplo",
  "gopls",
  "tsc",
}
