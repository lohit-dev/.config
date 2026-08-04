-- Lazy-loaded (load = false in init.lua's vim.pack.add) -- this is one of the
-- heaviest plugins in the whole config (own UI, HTTP calls to leetcode.com),
-- and it's only relevant during DSA practice sessions, not every session.
-- Its :Leet command is registered inside setup() itself (no plugin/ file),
-- so it genuinely doesn't exist until ensure_loaded() runs.
local loaded = false
local function ensure_loaded()
  if loaded then
    return
  end
  vim.cmd.packadd "leetcode.nvim"
  require("leetcode").setup {
    lang = "javascript",
    plugins = {
      non_standalone = true,
    },
  }
  loaded = true
end

local function leet_cmd(cmd)
  return function()
    ensure_loaded()
    vim.cmd(cmd)
  end
end

vim.keymap.set("n", "<leader>ll", leet_cmd "Leet", { desc = "LeetCode menu" })
vim.keymap.set("n", "<leader>ld", leet_cmd "Leet daily", { desc = "LeetCode daily" })
vim.keymap.set("n", "<leader>lr", leet_cmd "Leet random", { desc = "LeetCode random" })
vim.keymap.set("n", "<leader>lt", leet_cmd "Leet test", { desc = "LeetCode test" })
vim.keymap.set("n", "<leader>ls", leet_cmd "Leet submit", { desc = "LeetCode submit" })
vim.keymap.set("n", "<leader>lo", leet_cmd "Leet list", { desc = "LeetCode problem list" })
vim.keymap.set("n", "<leader>li", leet_cmd "Leet info", { desc = "LeetCode problem info" })
