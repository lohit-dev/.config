require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "dockerls", "yamlls", "gopls", "rust_analyzer" },
  automatic_enable = true, -- calls vim.lsp.enable() for you once installed
}
