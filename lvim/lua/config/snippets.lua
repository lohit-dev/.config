-- nvim-snippets: reads friendly-snippets' JSON and expands snippets through
-- Neovim's native vim.snippet API. No completion-engine plugin, so no
-- dropdown of suggestions -- this is UltiSnips-style: type a known prefix
-- (e.g. "fn", "for"), hit <Tab>, it expands; <Tab>/<S-Tab> then walk tabstops.
--
-- create_cmp_source is off (no nvim-cmp here), which also means the plugin
-- doesn't expose a public "expand at cursor" function -- that logic normally
-- lives inside its nvim-cmp source. expand_at_cursor() below replicates it:
-- same lookup (Snippets.load_snippets_for_ft), same var expansion
-- (Snippets.utils.expand_vars) that the cmp source itself calls.
require("snippets").setup {
  create_autocmd = true, -- load snippets on file open, since there's no cmp source to trigger it
  create_cmp_source = false,
  friendly_snippets = true,
}

local function expand_at_cursor()
  local snippets = require "snippets"
  local loaded = snippets.load_snippets_for_ft(vim.bo.filetype)
  if not loaded then
    return false
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local prefix = line:sub(1, col):match "[%w_%-]+$"
  if not prefix or not loaded[prefix] then
    return false
  end

  local body = loaded[prefix].body
  if type(body) == "table" then
    body = table.concat(body, "\n")
  end
  body = snippets.utils.expand_vars(body)

  vim.api.nvim_buf_set_text(0, row - 1, col - #prefix, row - 1, col, {})
  vim.snippet.expand(body)
  return true
end

vim.keymap.set("i", "<Tab>", function()
  if vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
    return
  end
  if expand_at_cursor() then
    return
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
end, { desc = "Expand snippet / next tabstop" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  end
end, { desc = "Previous snippet tabstop" })

vim.keymap.set("s", "<Tab>", function()
  if vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  end
end, { desc = "Next snippet tabstop" })
