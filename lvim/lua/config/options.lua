local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = false
opt.termguicolors = true
opt.mouse = "a"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.cursorlineopt = "number"
opt.laststatus = 3
opt.background = "dark"
opt.guicursor = ""
opt.wrap = true
opt.linebreak = true

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.updatetime = 250
opt.timeoutlen = 400

opt.undofile = true
opt.swapfile = false

opt.clipboard = "unnamedplus"
opt.scrolloff = 8

-- Native insert-mode completion (Neovim 0.12+), no completion plugin needed.
-- Paired with vim.lsp.completion.enable() per-client in keymaps.lua.
vim.opt.completeopt = {
  "menuone",
  "popup",
  "noinsert",
}
vim.o.autocomplete = true
