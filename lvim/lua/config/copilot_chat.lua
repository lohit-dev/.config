require("CopilotChat").setup {}

vim.keymap.set("n", "<leader>aa", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain with Copilot Chat" })
vim.keymap.set("x", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain selection with Copilot Chat" })
