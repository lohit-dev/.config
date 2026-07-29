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
    keymap = {
      accept = "<C-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
}
