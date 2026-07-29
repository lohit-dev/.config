require("overseer").setup {
  task_list = {
    direction = "bottom",
    min_height = 20,
    max_height = 20,
    default_detail = 1,
  },
}

vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run task" })
vim.keymap.set("n", "<leader>oc", ":OverseerShell ", { desc = "Run custom task command" })
