-- Format on save for Go/Rust/TS/JS, using each buffer's attached LSP client
-- directly (gopls/rust-analyzer/tsc all implement textDocument/formatting).
-- Go and TS/JS also get imports organized first, same as `goimports`.

local organize_imports_fts = {
  go = true,
  typescript = true,
  typescriptreact = true,
  javascript = true,
  javascriptreact = true,
}

-- Canonical pattern from gopls' own Neovim docs (go.dev/gopls/editor/vim),
-- generalized: works for any server that returns source.organizeImports.
local function organize_imports(bufnr, wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format-on-save", { clear = true }),
  pattern = { "*.go", "*.rs", "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function(args)
    local buf = args.buf
    if organize_imports_fts[vim.bo[buf].filetype] then
      organize_imports(buf, 1000)
    end
    vim.lsp.buf.format { bufnr = buf, async = false, timeout_ms = 3000 }
  end,
})
