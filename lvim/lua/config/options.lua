local opt = vim.opt
local settings = require "config.settings"

opt.number = settings.get "line_numbers"
opt.relativenumber = settings.get "line_numbers"
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
opt.laststatus = 0

opt.completeopt = {
  "menuone",
  "noinsert",
}

opt.shortmess:append("W")
opt.ruler = false
opt.cmdheight = 0

vim.deprecate = function() end
