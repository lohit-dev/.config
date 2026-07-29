-- rustaceanvim starts and owns the rust-analyzer client itself via its
-- ftplugin (after/ftplugin-style, on FileType rust) — no vim.lsp.enable,
-- no lsp/rust_analyzer.lua. This table is where the same rust-analyzer
-- settings that used to live in lsp/rust_analyzer.lua now go.
--
-- Must be set before any rust buffer is opened, hence required immediately
-- after vim.pack.add in init.lua rather than alongside the other config.* requires.
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          buildScripts = { enable = true },
        },
        check = { command = "clippy" },
        procMacro = { enable = true },
        inlayHints = {
          bindingModeHints = { enable = false },
          closureReturnTypeHints = { enable = "always" },
          lifetimeElisionHints = { enable = "skip_trivial" },
          typeHints = { enable = true },
        },
      },
    },
  },
}
