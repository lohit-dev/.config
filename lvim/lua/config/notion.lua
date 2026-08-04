-- notion.nvim: edit Notion pages as markdown buffers, synced back on `:w`.
-- Lazy-loaded (load = false in init.lua's vim.pack.add): plugin/notion.lua
-- and its Lua modules don't get sourced at startup, only on first use of any
-- <leader>n* keymap below via ensure_loaded()'s one-time :packadd + setup().
--
-- One-time setup:
--   1. Create an integration at https://www.notion.so/my-integrations
--   2. Share the target database/pages with that integration
--   3. export NOTION_TOKEN="..." (and NOTION_DATABASE_ID="..." if you want
--      :Notion edit scoped to a specific database, e.g. your DSA tracker
--      or job tracker)
local loaded = false
local function ensure_loaded()
  if loaded then
    return
  end
  vim.cmd.packadd "notion.nvim"
  require("notion").setup {
    use_telescope = true,
  }
  loaded = true
end

local function notion_cmd(cmd)
  return function()
    ensure_loaded()
    vim.cmd(cmd)
  end
end

vim.keymap.set("n", "<leader>nn", notion_cmd "Notion edit", { desc = "Browse & edit Notion pages" })
vim.keymap.set("n", "<leader>nc", function()
  ensure_loaded()
  vim.fn.feedkeys(":Notion create ", "n")
end, { desc = "Create Notion page" })
vim.keymap.set("n", "<leader>nd", notion_cmd "Notion delete", { desc = "Delete (archive) Notion page" })
vim.keymap.set("n", "<leader>nb", notion_cmd "NotionBrowser", { desc = "Open current page in browser" })
vim.keymap.set("n", "<leader>ns", notion_cmd "NotionSync", { desc = "Manually sync buffer to Notion" })
