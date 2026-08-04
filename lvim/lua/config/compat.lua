-- project.nvim (bundled with telescope's projects extension) still calls the
-- removed vim.lsp.buf_get_clients() internally -- Neovim keeps a compat shim
-- for it that works fine but prints a deprecation warning on every call.
-- There's no official flag to blanket-suppress deprecation warnings
-- (neovim/neovim#28845, closed wontfix), so instead of hiding warnings in
-- general, this replaces just that one function with a silent equivalent --
-- any other, future deprecation warning will still show up normally.
--
-- Must run before project.nvim's code path calls it, so this is required
-- first in init.lua, before vim.pack.add.
vim.lsp.buf_get_clients = function(bufnr)
  return vim.lsp.get_clients { bufnr = bufnr }
end
