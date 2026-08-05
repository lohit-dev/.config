-- notion.nvim: edit Notion pages as markdown buffers, synced back on `:w`.
-- One-time setup:
--   1. Create an integration at https://www.notion.so/my-integrations
--   2. Share the target database/pages with that integration
--   3. export NOTION_TOKEN="..." (and NOTION_DATABASE_ID="..." if you want
--      :Notion edit scoped to a specific database, e.g. your DSA tracker
--      or job tracker)
require("notion").setup {
  use_telescope = true,
}

vim.keymap.set("n", "<leader>nn", "<cmd>Notion edit<cr>", { desc = "Browse & edit Notion pages" })
vim.keymap.set("n", "<leader>nc", ":Notion create ", { desc = "Create Notion page" })
vim.keymap.set("n", "<leader>nd", "<cmd>Notion delete<cr>", { desc = "Delete (archive) Notion page" })
vim.keymap.set("n", "<leader>nb", "<cmd>NotionBrowser<cr>", { desc = "Open current page in browser" })
vim.keymap.set("n", "<leader>ns", "<cmd>NotionSync<cr>", { desc = "Manually sync buffer to Notion" })
