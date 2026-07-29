-- nvim-treesitter 'main' branch — full rewrite, Neovim 0.12+ only.
-- Requires the tree-sitter CLI on PATH (not the npm package):
--   brew install tree-sitter

require("nvim-treesitter").setup {}

local parsers = {
  "go",
  "gomod",
  "gowork",
  "gosum",
  "rust",
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  "dockerfile",
  "yaml",
  "html",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
}
require("nvim-treesitter").install(parsers)

local ft_group = vim.api.nvim_create_augroup("treesitter-start", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = {
    "go",
    "gomod",
    "gowork",
    "rust",
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "dockerfile",
    "yaml",
    "yaml.docker-compose",
    "yaml.github",
    "html",
    "lua",
    "vim",
    "markdown",
  },
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldenable = false -- don't collapse everything on open
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
