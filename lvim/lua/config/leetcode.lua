require("leetcode").setup {
  lang = "javascript",
  plugins = {
    non_standalone = true,
  },
}

vim.keymap.set("n", "<leader>ll", "<cmd>Leet<cr>", { desc = "LeetCode menu" })
vim.keymap.set("n", "<leader>ld", "<cmd>Leet daily<cr>", { desc = "LeetCode daily" })
vim.keymap.set("n", "<leader>lr", "<cmd>Leet random<cr>", { desc = "LeetCode random" })
vim.keymap.set("n", "<leader>lt", "<cmd>Leet test<cr>", { desc = "LeetCode test" })
vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "LeetCode submit" })
vim.keymap.set("n", "<leader>lo", "<cmd>Leet list<cr>", { desc = "LeetCode problem list" })
vim.keymap.set("n", "<leader>li", "<cmd>Leet info<cr>", { desc = "LeetCode problem info" })
