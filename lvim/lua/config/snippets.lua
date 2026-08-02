-- nvim-snippets reads friendly-snippets' JSON and registers its completion
-- source for nvim-cmp. Expansion itself uses Neovim's native vim.snippet API.
require("snippets").setup {
  create_autocmd = true,
  create_cmp_source = true,
  friendly_snippets = true,
}
