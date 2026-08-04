-- GitHub Copilot inline (ghost-text) suggestions.
--
-- Requires Node.js on $PATH (the Copilot language server runs on Node) and a
-- one-time `:Copilot auth` after first launch.
--
require("copilot").setup {
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    keymap = {
      accept = "<C-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
}

local settings = require "config.settings"
if not settings.get "copilot_enabled" then
  vim.cmd "Copilot disable"
end

vim.keymap.set("n", "<leader>an", function()
  settings.set("copilot_enabled", true)
  vim.cmd "Copilot enable"
end, { desc = "Enable Copilot" })
vim.keymap.set("n", "<leader>ad", function()
  settings.set("copilot_enabled", false)
  vim.cmd "Copilot disable"
end, { desc = "Disable Copilot" })
vim.keymap.set("n", "<leader>as", "<cmd>Copilot status<cr>", { desc = "Copilot status" })
vim.keymap.set(
  "n",
  "<leader>at",
  "<cmd>Copilot suggestion toggle_auto_trigger<cr>",
  { desc = "Toggle Copilot suggestions" }
)
