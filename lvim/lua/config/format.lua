-- Format on save for Go/Rust/TS/JS. Go/Rust use their LSP formatter directly
-- (gopls/rust-analyzer). TS/JS use Prettier when it's on $PATH: tsc's native
-- LSP (tsgo, "tsc --lsp --stdio") does implement textDocument/formatting, but it's syntax/token-based only -- it'll fix indentation and spacing but won't
-- reflow lines, wrap args, etc. like Prettier does. That's why it can look
-- like "nothing happened" on save even though nothing is erroring. Falls back
-- to the LSP formatter if prettier isn't installed, so no regression either way.
-- Go and TS/JS also get imports organized first, same as `goimports`.

local organize_imports_fts = {
  go = true,
  typescript = true,
  typescriptreact = true,
  javascript = true,
  javascriptreact = true,
}

local js_fts = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local has_prettier = vim.fn.executable "prettier" == 1

local function format_with_prettier(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = vim.system({ "prettier", "--stdin-filepath", filename }, { stdin = lines }):wait()
  if result.code ~= 0 then
    vim.notify("prettier: " .. (result.stderr or "format failed"), vim.log.levels.WARN)
    return
  end
  local new_lines = vim.split(result.stdout, "\n")
  if new_lines[#new_lines] == "" then
    table.remove(new_lines)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

-- Canonical pattern from gopls' own Neovim docs (go.dev/gopls/editor/vim),
-- generalized: works for any server that returns source.organizeImports.
local function organize_imports(bufnr, wait_ms)
  local enc = (vim.lsp.get_clients({ bufnr = bufnr })[1] or {}).offset_encoding or "utf-16"
  local params = vim.lsp.util.make_range_params(0, enc)
  ---@diagnostic disable-next-line: inject-field
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local client_enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, client_enc)
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
    if js_fts[vim.bo[buf].filetype] and has_prettier then
      format_with_prettier(buf)
    else
      vim.lsp.buf.format { bufnr = buf, async = false, timeout_ms = 3000 }
    end
  end,
})
